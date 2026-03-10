library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity uart_rx is
    Generic (
        CLKS_PER_BIT : integer := 434  -- 50MHz / 115200 baud = 434
    );
    Port (
        clk        : in  STD_LOGIC;
        rx         : in  STD_LOGIC;
        data_out   : out STD_LOGIC_VECTOR(7 downto 0);
        data_valid : out STD_LOGIC
    );
end uart_rx;

architecture Behavioral of uart_rx is
    type state_type is (IDLE, START_BIT, DATA_BITS, STOP_BIT);
    signal state : state_type := IDLE;
    
    signal clk_count : integer range 0 to CLKS_PER_BIT-1 := 0;
    signal bit_index : integer range 0 to 7 := 0;
    signal data_reg  : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
    signal rx_sync   : STD_LOGIC_VECTOR(1 downto 0) := (others => '1');
    
begin

    -- Synchronize incoming RX signal
    process(clk)
    begin
        if rising_edge(clk) then
            rx_sync <= rx_sync(0) & rx;
        end if;
    end process;

    -- UART RX State Machine
    process(clk)
    begin
        if rising_edge(clk) then
            data_valid <= '0';  -- Pulse, not held
            
            case state is
                when IDLE =>
                    clk_count <= 0;
                    bit_index <= 0;
                    
                    if rx_sync(1) = '0' then  -- Start bit detected
                        state <= START_BIT;
                    end if;
                
                when START_BIT =>
                    if clk_count = (CLKS_PER_BIT-1)/2 then
                        -- Middle of start bit
                        if rx_sync(1) = '0' then
                            clk_count <= 0;
                            state <= DATA_BITS;
                        else
                            state <= IDLE;  -- False start
                        end if;
                    else
                        clk_count <= clk_count + 1;
                    end if;
                
                when DATA_BITS =>
                    if clk_count < CLKS_PER_BIT-1 then
                        clk_count <= clk_count + 1;
                    else
                        clk_count <= 0;
                        data_reg(bit_index) <= rx_sync(1);
                        
                        if bit_index < 7 then
                            bit_index <= bit_index + 1;
                        else
                            bit_index <= 0;
                            state <= STOP_BIT;
                        end if;
                    end if;
                
                when STOP_BIT =>
                    if clk_count < CLKS_PER_BIT-1 then
                        clk_count <= clk_count + 1;
                    else
                        clk_count <= 0;
                        data_valid <= '1';
                        data_out <= data_reg;
                        state <= IDLE;
                    end if;
            end case;
        end if;
    end process;

end Behavioral;