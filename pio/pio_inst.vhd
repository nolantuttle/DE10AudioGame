	component pio is
		port (
			clk_clk                          : in    std_logic                     := 'X';             -- clk
			memory_0_mem_a                   : out   std_logic_vector(12 downto 0);                    -- mem_a
			memory_0_mem_ba                  : out   std_logic_vector(2 downto 0);                     -- mem_ba
			memory_0_mem_ck                  : out   std_logic;                                        -- mem_ck
			memory_0_mem_ck_n                : out   std_logic;                                        -- mem_ck_n
			memory_0_mem_cke                 : out   std_logic;                                        -- mem_cke
			memory_0_mem_cs_n                : out   std_logic;                                        -- mem_cs_n
			memory_0_mem_ras_n               : out   std_logic;                                        -- mem_ras_n
			memory_0_mem_cas_n               : out   std_logic;                                        -- mem_cas_n
			memory_0_mem_we_n                : out   std_logic;                                        -- mem_we_n
			memory_0_mem_reset_n             : out   std_logic;                                        -- mem_reset_n
			memory_0_mem_dq                  : inout std_logic_vector(7 downto 0)  := (others => 'X'); -- mem_dq
			memory_0_mem_dqs                 : inout std_logic                     := 'X';             -- mem_dqs
			memory_0_mem_dqs_n               : inout std_logic                     := 'X';             -- mem_dqs_n
			memory_0_mem_odt                 : out   std_logic;                                        -- mem_odt
			memory_0_mem_dm                  : out   std_logic;                                        -- mem_dm
			memory_0_oct_rzqin               : in    std_logic                     := 'X';             -- oct_rzqin
			pio_0_external_connection_export : in    std_logic_vector(3 downto 0)  := (others => 'X'); -- export
			reset_reset_n                    : in    std_logic                     := 'X';             -- reset_n
			hps_1_h2f_mpu_events_eventi      : in    std_logic                     := 'X';             -- eventi
			hps_1_h2f_mpu_events_evento      : out   std_logic;                                        -- evento
			hps_1_h2f_mpu_events_standbywfe  : out   std_logic_vector(1 downto 0);                     -- standbywfe
			hps_1_h2f_mpu_events_standbywfi  : out   std_logic_vector(1 downto 0)                      -- standbywfi
		);
	end component pio;

	u0 : component pio
		port map (
			clk_clk                          => CONNECTED_TO_clk_clk,                          --                       clk.clk
			memory_0_mem_a                   => CONNECTED_TO_memory_0_mem_a,                   --                  memory_0.mem_a
			memory_0_mem_ba                  => CONNECTED_TO_memory_0_mem_ba,                  --                          .mem_ba
			memory_0_mem_ck                  => CONNECTED_TO_memory_0_mem_ck,                  --                          .mem_ck
			memory_0_mem_ck_n                => CONNECTED_TO_memory_0_mem_ck_n,                --                          .mem_ck_n
			memory_0_mem_cke                 => CONNECTED_TO_memory_0_mem_cke,                 --                          .mem_cke
			memory_0_mem_cs_n                => CONNECTED_TO_memory_0_mem_cs_n,                --                          .mem_cs_n
			memory_0_mem_ras_n               => CONNECTED_TO_memory_0_mem_ras_n,               --                          .mem_ras_n
			memory_0_mem_cas_n               => CONNECTED_TO_memory_0_mem_cas_n,               --                          .mem_cas_n
			memory_0_mem_we_n                => CONNECTED_TO_memory_0_mem_we_n,                --                          .mem_we_n
			memory_0_mem_reset_n             => CONNECTED_TO_memory_0_mem_reset_n,             --                          .mem_reset_n
			memory_0_mem_dq                  => CONNECTED_TO_memory_0_mem_dq,                  --                          .mem_dq
			memory_0_mem_dqs                 => CONNECTED_TO_memory_0_mem_dqs,                 --                          .mem_dqs
			memory_0_mem_dqs_n               => CONNECTED_TO_memory_0_mem_dqs_n,               --                          .mem_dqs_n
			memory_0_mem_odt                 => CONNECTED_TO_memory_0_mem_odt,                 --                          .mem_odt
			memory_0_mem_dm                  => CONNECTED_TO_memory_0_mem_dm,                  --                          .mem_dm
			memory_0_oct_rzqin               => CONNECTED_TO_memory_0_oct_rzqin,               --                          .oct_rzqin
			pio_0_external_connection_export => CONNECTED_TO_pio_0_external_connection_export, -- pio_0_external_connection.export
			reset_reset_n                    => CONNECTED_TO_reset_reset_n,                    --                     reset.reset_n
			hps_1_h2f_mpu_events_eventi      => CONNECTED_TO_hps_1_h2f_mpu_events_eventi,      --      hps_1_h2f_mpu_events.eventi
			hps_1_h2f_mpu_events_evento      => CONNECTED_TO_hps_1_h2f_mpu_events_evento,      --                          .evento
			hps_1_h2f_mpu_events_standbywfe  => CONNECTED_TO_hps_1_h2f_mpu_events_standbywfe,  --                          .standbywfe
			hps_1_h2f_mpu_events_standbywfi  => CONNECTED_TO_hps_1_h2f_mpu_events_standbywfi   --                          .standbywfi
		);

