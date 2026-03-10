
module pio (
	clk_clk,
	memory_0_mem_a,
	memory_0_mem_ba,
	memory_0_mem_ck,
	memory_0_mem_ck_n,
	memory_0_mem_cke,
	memory_0_mem_cs_n,
	memory_0_mem_ras_n,
	memory_0_mem_cas_n,
	memory_0_mem_we_n,
	memory_0_mem_reset_n,
	memory_0_mem_dq,
	memory_0_mem_dqs,
	memory_0_mem_dqs_n,
	memory_0_mem_odt,
	memory_0_mem_dm,
	memory_0_oct_rzqin,
	pio_0_external_connection_export,
	reset_reset_n,
	hps_1_h2f_mpu_events_eventi,
	hps_1_h2f_mpu_events_evento,
	hps_1_h2f_mpu_events_standbywfe,
	hps_1_h2f_mpu_events_standbywfi);	

	input		clk_clk;
	output	[12:0]	memory_0_mem_a;
	output	[2:0]	memory_0_mem_ba;
	output		memory_0_mem_ck;
	output		memory_0_mem_ck_n;
	output		memory_0_mem_cke;
	output		memory_0_mem_cs_n;
	output		memory_0_mem_ras_n;
	output		memory_0_mem_cas_n;
	output		memory_0_mem_we_n;
	output		memory_0_mem_reset_n;
	inout	[7:0]	memory_0_mem_dq;
	inout		memory_0_mem_dqs;
	inout		memory_0_mem_dqs_n;
	output		memory_0_mem_odt;
	output		memory_0_mem_dm;
	input		memory_0_oct_rzqin;
	input	[3:0]	pio_0_external_connection_export;
	input		reset_reset_n;
	input		hps_1_h2f_mpu_events_eventi;
	output		hps_1_h2f_mpu_events_evento;
	output	[1:0]	hps_1_h2f_mpu_events_standbywfe;
	output	[1:0]	hps_1_h2f_mpu_events_standbywfi;
endmodule
