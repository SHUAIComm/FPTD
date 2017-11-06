module Turbo_PCIE(
	input OSC_50_BANK2,
	input PCIE_PREST_n,
	input ASIC_RESET,
	input PCIE_REFCLK_p,
	input [7:0] PCIE_RX_p,
    ///////// ASIC /////////
    output                                      ASIC_nReset,
    output                                      ASIC_Clock,
    output                                      ASIC_Go,
    output                                      ASIC_Mode,
    output                                      ASIC_Enable_f,
    output                                      ASIC_Sel_f,
    output                                      ASIC_S1,
    output                                      ASIC_S2,
    output                                      ASIC_S3,
    output      [6:0]                           ASIC_In,

    input       [6:0]                           ASIC_DOut1,
    input       [6:0]                           ASIC_DOut2,
    input       [6:0]                           ASIC_TOut,
    input                                       ASIC_bitout1,
    input                                       ASIC_bitout2,
    input                                       ASIC_KeepShift,
    input                                       ASIC_Start,
    input                                       ASIC_Start2,
    input                                       ASIC_TestReady,
    input                                       ASIC_Dclk,
    
    ///////// FAN /////////
    inout FAN_CTRL,
    input [3:0] SW,

    ///////// LED /////////
    output [3:0] LED,
    output [7:0] PCIE_TX_p
);
	wire clk50, clk125;
	
	wire fan_slow;
	wire [3:0] LED_tmp;

	assign LED = SW[1] ? LED_tmp : 4'b1111;
	assign FAN_CTRL = SW[0] ? fan_slow : 1'b1;

	fan_freq fan_freq_ctrl(
		.clk(OSC_50_BANK2),
		.fan(fan_slow),
		.led(LED_tmp)
	);
	
	my_pll pll_inst(
		.inclk0 (OSC_50_BANK2),
		.c0 (clk50),
		.c1 (clk125)
	);

	qsys_system system_inst(
		.clk_clk (clk50),
		.pcie_ip_refclk_export (PCIE_REFCLK_p),
		.asic_avalon_reset_reset_n (ASIC_RESET),
		.pcie_ip_fixedclk_clk (clk125),
		.reset_reset_n (1'b1),
		.pcie_ip_pcie_rstn_export (PCIE_PREST_n),
		.pcie_ip_rx_in_rx_datain_0 (PCIE_RX_p[0]),
		.pcie_ip_rx_in_rx_datain_1 (PCIE_RX_p[1]),
		.pcie_ip_rx_in_rx_datain_2 (PCIE_RX_p[2]),
		.pcie_ip_rx_in_rx_datain_3 (PCIE_RX_p[3]),
		.pcie_ip_rx_in_rx_datain_4 (PCIE_RX_p[4]),
		.pcie_ip_rx_in_rx_datain_5 (PCIE_RX_p[5]),
		.pcie_ip_rx_in_rx_datain_6 (PCIE_RX_p[6]),
		.pcie_ip_rx_in_rx_datain_7 (PCIE_RX_p[7]),
		.pcie_ip_tx_out_tx_dataout_0 (PCIE_TX_p[0]),
		.pcie_ip_tx_out_tx_dataout_1 (PCIE_TX_p[1]),
		.pcie_ip_tx_out_tx_dataout_2 (PCIE_TX_p[2]),
		.pcie_ip_tx_out_tx_dataout_3 (PCIE_TX_p[3]),
		.pcie_ip_tx_out_tx_dataout_4 (PCIE_TX_p[4]),
		.pcie_ip_tx_out_tx_dataout_5 (PCIE_TX_p[5]),
		.pcie_ip_tx_out_tx_dataout_6 (PCIE_TX_p[6]),
		.pcie_ip_tx_out_tx_dataout_7 (PCIE_TX_p[7]),
        ///////// ASIC /////////
        .asic_avalon_0_asic_bitout1_data(ASIC_bitout1),         
        .asic_avalon_0_asic_bitout2_data(ASIC_bitout2),         
        .asic_avalon_0_asic_clock_clk(ASIC_Clock),            
        .asic_avalon_0_asic_dclk_data(ASIC_Dclk),            
        .asic_avalon_0_asic_dout1_data(ASIC_DOut1),           
        .asic_avalon_0_asic_dout2_data(ASIC_DOut2),           
        .asic_avalon_0_asic_enable_f_data(ASIC_Enable_f),        
        .asic_avalon_0_asic_go_data(ASIC_Go),              
        .asic_avalon_0_asic_in_data(ASIC_In),              
        .asic_avalon_0_asic_keepshift_data(ASIC_KeepShift),       
        .asic_avalon_0_asic_mode_data(ASIC_Mode),            
        .asic_avalon_0_asic_nreset_data(ASIC_nReset),          
        .asic_avalon_0_asic_s1_data(ASIC_S1),              
        .asic_avalon_0_asic_s2_data(ASIC_S2),              
        .asic_avalon_0_asic_s3_data(ASIC_S3),              
        .asic_avalon_0_asic_sel_f_data(ASIC_Sel_f),           
        .asic_avalon_0_asic_start_data(ASIC_Start),           
        .asic_avalon_0_asic_start2_data(ASIC_Start2),          
        .asic_avalon_0_asic_switch_fpga_asic_data(SW[2]),
        .asic_avalon_0_asic_testready_data(ASIC_TestReady),       
        .asic_avalon_0_asic_tout_data(ASIC_TOut)
	);
endmodule