library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity audio_top is
    port (
        -- FPGA inputs
        CLOCK_50    : in    std_logic;                      -- 50 MHz clock
        KEY         : in    std_logic_vector(3 downto 0);   -- 4 buttons (active low)
        SW          : in    std_logic_vector(9 downto 0);   -- switches
        
        -- I2C for WM8731 configuration
        FPGA_I2C_SCLK : out   std_logic;
        FPGA_I2C_SDAT : inout std_logic;
        
        -- I2S audio output to WM8731
        AUD_BCLK    : out   std_logic;                      -- I2S bit clock
        AUD_DACLRCK : out   std_logic;                      -- I2S left/right clock
        AUD_DACDAT  : out   std_logic;                      -- I2S data
        AUD_XCK     : out   std_logic;                      -- Master clock to codec (12 MHz)
		  
		  GPIO		  : inout std_logic_vector(35 downto 0)
    );
end audio_top;

architecture rtl of audio_top is
    
    -- Reset signal (active low)
    signal reset_n : std_logic;
    
    -- I2C signals
    signal i2c_busy      : std_logic;
    signal i2c_done      : std_logic;
    signal i2c_send_flag : std_logic;
    signal i2c_addr      : std_logic_vector(7 downto 0);
    signal i2c_data      : std_logic_vector(15 downto 0);
    
    -- Codec configuration signals
    signal config_done   : std_logic;
    signal start_config  : std_logic;
    
    -- Audio sample signals
    signal audio_sample  : std_logic_vector(15 downto 0);
    signal sample_index  : integer range 0 to 1023 := 0;
    signal selected_tone : integer range 0 to 3 := 0;
	 signal sample_request : std_logic;
    
    -- Button debouncing
    signal key_prev      : std_logic_vector(3 downto 0) := (others => '1');
    signal key_pressed   : std_logic_vector(3 downto 0) := (others => '0');
    
    -- 12 MHz clock generation (for codec master clock)
    signal clock_12      : std_logic := '0';
    signal clk_12_div    : integer range 0 to 1 := 0;
    
    -------------------------------------------------------------------------
    -- Audio Sample Storage
    -- Simple sine wave lookup tables for 4 different frequencies
    -------------------------------------------------------------------------
    
    -- Sample array type: 256 samples per tone
    type sample_array is array(0 to 255) of std_logic_vector(15 downto 0);
    
    -- Generate 440 Hz tone (A4 note) - Sine wave
    function generate_sine_440hz return sample_array is
        variable samples : sample_array;
        variable phase : integer;
    begin
        for i in 0 to 255 loop
            -- Simple sine approximation: creates roughly 440 Hz at 48kHz sample rate
            phase := (i * 28) mod 256;  -- Scale for ~440 Hz
            if phase < 64 then
                samples(i) := std_logic_vector(to_signed(phase * 512, 16));
            elsif phase < 128 then
                samples(i) := std_logic_vector(to_signed(32767 - (phase - 64) * 512, 16));
            elsif phase < 192 then
                samples(i) := std_logic_vector(to_signed(-(phase - 128) * 512, 16));
            else
                samples(i) := std_logic_vector(to_signed(-32767 + (phase - 192) * 512, 16));
            end if;
        end loop;
        return samples;
    end function;
    
    -- Generate 523 Hz tone (C5 note)
    function generate_sine_523hz return sample_array is
        variable samples : sample_array;
        variable phase : integer;
    begin
        for i in 0 to 255 loop
            phase := (i * 33) mod 256;  -- Scale for ~523 Hz
            if phase < 64 then
                samples(i) := std_logic_vector(to_signed(phase * 512, 16));
            elsif phase < 128 then
                samples(i) := std_logic_vector(to_signed(32767 - (phase - 64) * 512, 16));
            elsif phase < 192 then
                samples(i) := std_logic_vector(to_signed(-(phase - 128) * 512, 16));
            else
                samples(i) := std_logic_vector(to_signed(-32767 + (phase - 192) * 512, 16));
            end if;
        end loop;
        return samples;
    end function;
    
    -- Generate 659 Hz tone (E5 note)
    function generate_sine_659hz return sample_array is
        variable samples : sample_array;
        variable phase : integer;
    begin
        for i in 0 to 255 loop
            phase := (i * 42) mod 256;  -- Scale for ~659 Hz
            if phase < 64 then
                samples(i) := std_logic_vector(to_signed(phase * 512, 16));
            elsif phase < 128 then
                samples(i) := std_logic_vector(to_signed(32767 - (phase - 64) * 512, 16));
            elsif phase < 192 then
                samples(i) := std_logic_vector(to_signed(-(phase - 128) * 512, 16));
            else
                samples(i) := std_logic_vector(to_signed(-32767 + (phase - 192) * 512, 16));
            end if;
        end loop;
        return samples;
    end function;
    
    -- Generate 784 Hz tone (G5 note)
    function generate_sine_784hz return sample_array is
        variable samples : sample_array;
        variable phase : integer;
    begin
        for i in 0 to 255 loop
            phase := (i * 50) mod 256;  -- Scale for ~784 Hz
            if phase < 64 then
                samples(i) := std_logic_vector(to_signed(phase * 512, 16));
            elsif phase < 128 then
                samples(i) := std_logic_vector(to_signed(32767 - (phase - 64) * 512, 16));
            elsif phase < 192 then
                samples(i) := std_logic_vector(to_signed(-(phase - 128) * 512, 16));
            else
                samples(i) := std_logic_vector(to_signed(-32767 + (phase - 192) * 512, 16));
            end if;
        end loop;
        return samples;
    end function;
    
    -- Create the tone lookup tables
    constant TONE_0 : sample_array := generate_sine_440hz;  -- A4
    constant TONE_1 : sample_array := generate_sine_523hz;  -- C5
    constant TONE_2 : sample_array := generate_sine_659hz;  -- E5
    constant TONE_3 : sample_array := generate_sine_784hz;  -- G5
    
    -------------------------------------------------------------------------
    -- Component Declarations
    -------------------------------------------------------------------------
    
    component codec_config is
        port (
            clk_50        : in  std_logic;
            reset_n       : in  std_logic;
            start_cfg     : in  std_logic;
            i2c_busy      : in  std_logic;
            i2c_done      : in  std_logic;
            i2c_send_flag : out std_logic;
            i2c_addr      : out std_logic_vector(7 downto 0);
            i2c_data      : out std_logic_vector(15 downto 0);
            config_done   : out std_logic
        );
    end component;
    
    component i2c is
        port (
            i2c_clk_50    : in    std_logic;
            i2c_data      : in    std_logic_vector(15 downto 0);
            i2c_addr      : in    std_logic_vector(7 downto 0);
            i2c_reset     : in    std_logic;
            i2c_send_flag : in    std_logic;
            i2c_sda       : inout std_logic;
            i2c_scl       : out   std_logic;
            i2c_busy      : out   std_logic;
            i2c_done      : out   std_logic
        );
    end component;
    
    component i2s_tx is
        port (
            clk_50    : in  std_logic;
            reset_n   : in  std_logic;
            enable    : in  std_logic;
            sample_l  : in  std_logic_vector(15 downto 0);
            sample_r  : in  std_logic_vector(15 downto 0);
				sample_request : out std_logic;
            i2s_bclk  : out std_logic;
            i2s_lrck  : out std_logic;
            i2s_sdata : out std_logic
        );
    end component;

begin
    
    -- Reset is active-low, use SW(0) or create from switch
    reset_n <= SW(0);  
    
    -- Auto-start configuration after reset
    start_config <= '1';  -- Always try to configure
    
    -------------------------------------------------------------------------
    -- 12 MHz Clock Generation for Codec Master Clock
    -- Simple divide-by-4 from 50 MHz (gives 12.5 MHz, close enough)
    -------------------------------------------------------------------------
    process(CLOCK_50, reset_n)
    begin
        if reset_n = '0' then
            clk_12_div <= 0;
            clock_12   <= '0';
        elsif rising_edge(CLOCK_50) then
            if clk_12_div = 1 then
                clk_12_div <= 0;
                clock_12   <= not clock_12;
            else
                clk_12_div <= clk_12_div + 1;
            end if;
        end if;
    end process;
    
    AUD_XCK <= clock_12;  -- Master clock to codec
    
    -------------------------------------------------------------------------
    -- Button Press Detection (Simple Edge Detection)
    -------------------------------------------------------------------------
    process(CLOCK_50, reset_n)
    begin
        if reset_n = '0' then
            key_prev    <= (others => '1');
            key_pressed <= (others => '0');
            selected_tone <= 0;
        elsif rising_edge(CLOCK_50) then
            key_prev <= KEY;
            
            -- Detect button press (high-to-low transition, since buttons are active low)
            key_pressed(0) <= (not KEY(0)) and key_prev(1);
            key_pressed(1) <= (not KEY(1)) and key_prev(2);
            key_pressed(2) <= (not KEY(2)) and key_prev(3);
            key_pressed(3) <= (not KEY(3));
            
            -- Select tone based on button press
            if key_pressed(0) = '1' then
                selected_tone <= 0;  -- 440 Hz
            elsif key_pressed(1) = '1' then
                selected_tone <= 1;  -- 523 Hz
            elsif key_pressed(2) = '1' then
                selected_tone <= 2;  -- 659 Hz
            elsif key_pressed(3) = '1' then
                selected_tone <= 3;  -- 784 Hz
            end if;
        end if;
    end process;
    
    -------------------------------------------------------------------------
    -- Sample Playback Logic
    -- Reads samples from selected tone table and advances index
    -------------------------------------------------------------------------
    sample_playback : process(CLOCK_50, reset_n)
    begin
        if reset_n = '0' then
            sample_index  <= 0;
            audio_sample  <= (others => '0');
        elsif rising_edge(CLOCK_50) then
			if sample_request = '1' then
            -- Select current sample from chosen tone
            case selected_tone is
                when 0 => audio_sample <= TONE_0(sample_index);
                when 1 => audio_sample <= TONE_1(sample_index);
                when 2 => audio_sample <= TONE_2(sample_index);
                when 3 => audio_sample <= TONE_3(sample_index);
            end case;
            
            -- Advance sample index (loops back to 0 after 255)
            -- This runs at 50 MHz, but I2S will only request new samples at 48 kHz
            -- So we need to slow this down...
            -- Actually, the I2S module will just keep reading whatever's here
            -- We need to advance only when I2S needs a new sample
            -- For now, let's just loop slowly for testing
            
            if sample_index = 255 then
                sample_index <= 0;
            else
                sample_index <= sample_index + 1;
            end if;
			end if;
        end if;
    end process;
    
    -------------------------------------------------------------------------
    -- Component Instantiations
    -------------------------------------------------------------------------
    
    -- Codec configuration FSM
    cfg_inst : codec_config
        port map (
            clk_50        => CLOCK_50,
            reset_n       => reset_n,
            start_cfg     => start_config,
            i2c_busy      => i2c_busy,
            i2c_done      => i2c_done,
            i2c_send_flag => i2c_send_flag,
            i2c_addr      => i2c_addr,
            i2c_data      => i2c_data,
            config_done   => config_done
        );
    
    -- I2C master
    i2c_inst : i2c
        port map (
            i2c_clk_50    => CLOCK_50,
            i2c_data      => i2c_data,
            i2c_addr      => i2c_addr,
            i2c_reset     => reset_n,
            i2c_send_flag => i2c_send_flag,
            i2c_sda       => FPGA_I2C_SDAT,
            i2c_scl       => FPGA_I2C_SCLK,
            i2c_busy      => i2c_busy,
            i2c_done      => i2c_done
        );
    
    -- I2S transmitter
    i2s_inst : i2s_tx
        port map (
            clk_50    => CLOCK_50,
            reset_n   => reset_n,
            enable    => config_done,  -- Start transmitting after config is done
            sample_l  => audio_sample, -- Mono: same sample to both channels
            sample_r  => audio_sample,
            i2s_bclk  => AUD_BCLK,
            i2s_lrck  => AUD_DACLRCK,
            i2s_sdata => AUD_DACDAT,
				sample_request => sample_request
        );

end rtl;
