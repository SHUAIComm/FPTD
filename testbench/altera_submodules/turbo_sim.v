// turbo_sim.v

// Generated using ACDS version 16.0 211

`timescale 1 ps / 1 ps
module turbo_sim (
		input  wire       asic_avalon_0_asic_bitout1_data,          //          asic_avalon_0_asic_bitout1.data
		input  wire       asic_avalon_0_asic_bitout2_data,          //          asic_avalon_0_asic_bitout2.data
		output wire       asic_avalon_0_asic_clock_clk,             //            asic_avalon_0_asic_clock.clk
		input  wire       asic_avalon_0_asic_dclk_data,             //             asic_avalon_0_asic_dclk.data
		input  wire [6:0] asic_avalon_0_asic_dout1_data,            //            asic_avalon_0_asic_dout1.data
		input  wire [6:0] asic_avalon_0_asic_dout2_data,            //            asic_avalon_0_asic_dout2.data
		output wire       asic_avalon_0_asic_enable_f_data,         //         asic_avalon_0_asic_enable_f.data
		output wire       asic_avalon_0_asic_go_data,               //               asic_avalon_0_asic_go.data
		output wire [6:0] asic_avalon_0_asic_in_data,               //               asic_avalon_0_asic_in.data
		input  wire       asic_avalon_0_asic_keepshift_data,        //        asic_avalon_0_asic_keepshift.data
		output wire       asic_avalon_0_asic_mode_data,             //             asic_avalon_0_asic_mode.data
		output wire       asic_avalon_0_asic_nreset_data,           //           asic_avalon_0_asic_nreset.data
		output wire       asic_avalon_0_asic_s1_data,               //               asic_avalon_0_asic_s1.data
		output wire       asic_avalon_0_asic_s2_data,               //               asic_avalon_0_asic_s2.data
		output wire       asic_avalon_0_asic_s3_data,               //               asic_avalon_0_asic_s3.data
		output wire       asic_avalon_0_asic_sel_f_data,            //            asic_avalon_0_asic_sel_f.data
		input  wire       asic_avalon_0_asic_start_data,            //            asic_avalon_0_asic_start.data
		input  wire       asic_avalon_0_asic_start2_data,           //           asic_avalon_0_asic_start2.data
		input  wire       asic_avalon_0_asic_switch_fpga_asic_data, // asic_avalon_0_asic_switch_fpga_asic.data
		input  wire       asic_avalon_0_asic_testready_data,        //        asic_avalon_0_asic_testready.data
		input  wire [6:0] asic_avalon_0_asic_tout_data,             //             asic_avalon_0_asic_tout.data
		input  wire       clk_clk,                                  //                                 clk.clk
		input  wire       reset_reset_n                             //                               reset.reset_n
	);

	wire   [0:0] st_source_bfm_0_src_valid;                         // st_source_bfm_0:src_valid -> st_64_inv_0:avalon_streaming_sink_valid
	wire  [31:0] st_source_bfm_0_src_data;                          // st_source_bfm_0:src_data -> st_64_inv_0:avalon_streaming_sink_data
	wire         st_source_bfm_0_src_ready;                         // st_64_inv_0:avalon_streaming_sink_ready -> st_source_bfm_0:src_ready
	wire   [0:0] st_source_bfm_0_src_startofpacket;                 // st_source_bfm_0:src_startofpacket -> st_64_inv_0:avalon_streaming_sink_startofpacket
	wire   [0:0] st_source_bfm_0_src_endofpacket;                   // st_source_bfm_0:src_endofpacket -> st_64_inv_0:avalon_streaming_sink_endofpacket
	wire         st_64_inv_0_avalon_streaming_source_valid;         // st_64_inv_0:avalon_streaming_source_valid -> avalon_st_adapter:in_0_valid
	wire  [31:0] st_64_inv_0_avalon_streaming_source_data;          // st_64_inv_0:avalon_streaming_source_data -> avalon_st_adapter:in_0_data
	wire         st_64_inv_0_avalon_streaming_source_ready;         // avalon_st_adapter:in_0_ready -> st_64_inv_0:avalon_streaming_source_ready
	wire         st_64_inv_0_avalon_streaming_source_startofpacket; // st_64_inv_0:avalon_streaming_source_startofpacket -> avalon_st_adapter:in_0_startofpacket
	wire         st_64_inv_0_avalon_streaming_source_endofpacket;   // st_64_inv_0:avalon_streaming_source_endofpacket -> avalon_st_adapter:in_0_endofpacket
	wire         avalon_st_adapter_out_0_valid;                     // avalon_st_adapter:out_0_valid -> sc_fifo_0:in_valid
	wire  [31:0] avalon_st_adapter_out_0_data;                      // avalon_st_adapter:out_0_data -> sc_fifo_0:in_data
	wire         avalon_st_adapter_out_0_ready;                     // sc_fifo_0:in_ready -> avalon_st_adapter:out_0_ready
	wire         avalon_st_adapter_out_0_startofpacket;             // avalon_st_adapter:out_0_startofpacket -> sc_fifo_0:in_startofpacket
	wire         avalon_st_adapter_out_0_endofpacket;               // avalon_st_adapter:out_0_endofpacket -> sc_fifo_0:in_endofpacket
	wire   [1:0] avalon_st_adapter_out_0_empty;                     // avalon_st_adapter:out_0_empty -> sc_fifo_0:in_empty
	wire         sc_fifo_0_out_valid;                               // sc_fifo_0:out_valid -> avalon_st_adapter_001:in_0_valid
	wire  [31:0] sc_fifo_0_out_data;                                // sc_fifo_0:out_data -> avalon_st_adapter_001:in_0_data
	wire         sc_fifo_0_out_ready;                               // avalon_st_adapter_001:in_0_ready -> sc_fifo_0:out_ready
	wire         sc_fifo_0_out_startofpacket;                       // sc_fifo_0:out_startofpacket -> avalon_st_adapter_001:in_0_startofpacket
	wire         sc_fifo_0_out_endofpacket;                         // sc_fifo_0:out_endofpacket -> avalon_st_adapter_001:in_0_endofpacket
	wire   [1:0] sc_fifo_0_out_empty;                               // sc_fifo_0:out_empty -> avalon_st_adapter_001:in_0_empty
	wire         avalon_st_adapter_001_out_0_valid;                 // avalon_st_adapter_001:out_0_valid -> ASIC_avalon_0:sink_valid
	wire  [31:0] avalon_st_adapter_001_out_0_data;                  // avalon_st_adapter_001:out_0_data -> ASIC_avalon_0:sink_data
	wire         avalon_st_adapter_001_out_0_ready;                 // ASIC_avalon_0:sink_ready -> avalon_st_adapter_001:out_0_ready
	wire         avalon_st_adapter_001_out_0_startofpacket;         // avalon_st_adapter_001:out_0_startofpacket -> ASIC_avalon_0:sink_sop
	wire         avalon_st_adapter_001_out_0_endofpacket;           // avalon_st_adapter_001:out_0_endofpacket -> ASIC_avalon_0:sink_eop
	wire         sc_fifo_1_out_valid;                               // sc_fifo_1:out_valid -> avalon_st_adapter_002:in_0_valid
	wire  [31:0] sc_fifo_1_out_data;                                // sc_fifo_1:out_data -> avalon_st_adapter_002:in_0_data
	wire         sc_fifo_1_out_ready;                               // avalon_st_adapter_002:in_0_ready -> sc_fifo_1:out_ready
	wire         sc_fifo_1_out_startofpacket;                       // sc_fifo_1:out_startofpacket -> avalon_st_adapter_002:in_0_startofpacket
	wire         sc_fifo_1_out_endofpacket;                         // sc_fifo_1:out_endofpacket -> avalon_st_adapter_002:in_0_endofpacket
	wire   [1:0] sc_fifo_1_out_empty;                               // sc_fifo_1:out_empty -> avalon_st_adapter_002:in_0_empty
	wire         avalon_st_adapter_002_out_0_valid;                 // avalon_st_adapter_002:out_0_valid -> st_sink_bfm_0:sink_valid
	wire  [31:0] avalon_st_adapter_002_out_0_data;                  // avalon_st_adapter_002:out_0_data -> st_sink_bfm_0:sink_data
	wire         avalon_st_adapter_002_out_0_ready;                 // st_sink_bfm_0:sink_ready -> avalon_st_adapter_002:out_0_ready
	wire         avalon_st_adapter_002_out_0_startofpacket;         // avalon_st_adapter_002:out_0_startofpacket -> st_sink_bfm_0:sink_startofpacket
	wire         avalon_st_adapter_002_out_0_endofpacket;           // avalon_st_adapter_002:out_0_endofpacket -> st_sink_bfm_0:sink_endofpacket
	wire         asic_avalon_0_source_valid;                        // ASIC_avalon_0:source_valid -> avalon_st_adapter_003:in_0_valid
	wire  [31:0] asic_avalon_0_source_data;                         // ASIC_avalon_0:source_data -> avalon_st_adapter_003:in_0_data
	wire         asic_avalon_0_source_ready;                        // avalon_st_adapter_003:in_0_ready -> ASIC_avalon_0:source_ready
	wire         asic_avalon_0_source_startofpacket;                // ASIC_avalon_0:source_sop -> avalon_st_adapter_003:in_0_startofpacket
	wire         asic_avalon_0_source_endofpacket;                  // ASIC_avalon_0:source_eop -> avalon_st_adapter_003:in_0_endofpacket
	wire         avalon_st_adapter_003_out_0_valid;                 // avalon_st_adapter_003:out_0_valid -> sc_fifo_1:in_valid
	wire  [31:0] avalon_st_adapter_003_out_0_data;                  // avalon_st_adapter_003:out_0_data -> sc_fifo_1:in_data
	wire         avalon_st_adapter_003_out_0_ready;                 // sc_fifo_1:in_ready -> avalon_st_adapter_003:out_0_ready
	wire         avalon_st_adapter_003_out_0_startofpacket;         // avalon_st_adapter_003:out_0_startofpacket -> sc_fifo_1:in_startofpacket
	wire         avalon_st_adapter_003_out_0_endofpacket;           // avalon_st_adapter_003:out_0_endofpacket -> sc_fifo_1:in_endofpacket
	wire   [1:0] avalon_st_adapter_003_out_0_empty;                 // avalon_st_adapter_003:out_0_empty -> sc_fifo_1:in_empty
	wire         rst_controller_reset_out_reset;                    // rst_controller:reset_out -> [ASIC_avalon_0:resetn, avalon_st_adapter:in_rst_0_reset, avalon_st_adapter_001:in_rst_0_reset, avalon_st_adapter_002:in_rst_0_reset, avalon_st_adapter_003:in_rst_0_reset, sc_fifo_0:reset, sc_fifo_1:reset, st_64_inv_0:reset_reset, st_sink_bfm_0:reset, st_source_bfm_0:reset]

	ASIC_avalon asic_avalon_0 (
		.clk              (clk_clk),                                   //                 clock.clk
		.resetn           (~rst_controller_reset_out_reset),           //                 reset.reset_n
		.sink_data        (avalon_st_adapter_001_out_0_data),          //                  sink.data
		.sink_eop         (avalon_st_adapter_001_out_0_endofpacket),   //                      .endofpacket
		.sink_ready       (avalon_st_adapter_001_out_0_ready),         //                      .ready
		.sink_sop         (avalon_st_adapter_001_out_0_startofpacket), //                      .startofpacket
		.sink_valid       (avalon_st_adapter_001_out_0_valid),         //                      .valid
		.source_data      (asic_avalon_0_source_data),                 //                source.data
		.source_eop       (asic_avalon_0_source_endofpacket),          //                      .endofpacket
		.source_ready     (asic_avalon_0_source_ready),                //                      .ready
		.source_sop       (asic_avalon_0_source_startofpacket),        //                      .startofpacket
		.source_valid     (asic_avalon_0_source_valid),                //                      .valid
		.ASIC_DOut1       (asic_avalon_0_asic_dout1_data),             //            asic_dout1.data
		.ASIC_DOut2       (asic_avalon_0_asic_dout2_data),             //            asic_dout2.data
		.ASIC_Dclk        (asic_avalon_0_asic_dclk_data),              //             asic_dclk.data
		.ASIC_KeepShift   (asic_avalon_0_asic_keepshift_data),         //        asic_keepshift.data
		.ASIC_Start       (asic_avalon_0_asic_start_data),             //            asic_start.data
		.ASIC_Start2      (asic_avalon_0_asic_start2_data),            //           asic_start2.data
		.ASIC_TOut        (asic_avalon_0_asic_tout_data),              //             asic_tout.data
		.ASIC_TestReady   (asic_avalon_0_asic_testready_data),         //        asic_testready.data
		.ASIC_bitout1     (asic_avalon_0_asic_bitout1_data),           //          asic_bitout1.data
		.ASIC_bitout2     (asic_avalon_0_asic_bitout2_data),           //          asic_bitout2.data
		.switch_fpga_asic (asic_avalon_0_asic_switch_fpga_asic_data),  // asic_switch_fpga_asic.data
		.ASIC_Clock       (asic_avalon_0_asic_clock_clk),              //            asic_clock.clk
		.ASIC_nReset      (asic_avalon_0_asic_nreset_data),            //           asic_nreset.data
		.ASIC_Enable_f    (asic_avalon_0_asic_enable_f_data),          //         asic_enable_f.data
		.ASIC_Go          (asic_avalon_0_asic_go_data),                //               asic_go.data
		.ASIC_In          (asic_avalon_0_asic_in_data),                //               asic_in.data
		.ASIC_Sel_f       (asic_avalon_0_asic_sel_f_data),             //            asic_sel_f.data
		.ASIC_Mode        (asic_avalon_0_asic_mode_data),              //             asic_mode.data
		.ASIC_S1          (asic_avalon_0_asic_s1_data),                //               asic_s1.data
		.ASIC_S2          (asic_avalon_0_asic_s2_data),                //               asic_s2.data
		.ASIC_S3          (asic_avalon_0_asic_s3_data)                 //               asic_s3.data
	);

	altera_avalon_sc_fifo #(
		.SYMBOLS_PER_BEAT    (4),
		.BITS_PER_SYMBOL     (8),
		.FIFO_DEPTH          (512),
		.CHANNEL_WIDTH       (0),
		.ERROR_WIDTH         (0),
		.USE_PACKETS         (1),
		.USE_FILL_LEVEL      (1),
		.EMPTY_LATENCY       (3),
		.USE_MEMORY_BLOCKS   (1),
		.USE_STORE_FORWARD   (1),
		.USE_ALMOST_FULL_IF  (0),
		.USE_ALMOST_EMPTY_IF (0)
	) sc_fifo_0 (
		.clk               (clk_clk),                               //       clk.clk
		.reset             (rst_controller_reset_out_reset),        // clk_reset.reset
		.csr_address       (),                                      //       csr.address
		.csr_read          (),                                      //          .read
		.csr_write         (),                                      //          .write
		.csr_readdata      (),                                      //          .readdata
		.csr_writedata     (),                                      //          .writedata
		.in_data           (avalon_st_adapter_out_0_data),          //        in.data
		.in_valid          (avalon_st_adapter_out_0_valid),         //          .valid
		.in_ready          (avalon_st_adapter_out_0_ready),         //          .ready
		.in_startofpacket  (avalon_st_adapter_out_0_startofpacket), //          .startofpacket
		.in_endofpacket    (avalon_st_adapter_out_0_endofpacket),   //          .endofpacket
		.in_empty          (avalon_st_adapter_out_0_empty),         //          .empty
		.out_data          (sc_fifo_0_out_data),                    //       out.data
		.out_valid         (sc_fifo_0_out_valid),                   //          .valid
		.out_ready         (sc_fifo_0_out_ready),                   //          .ready
		.out_startofpacket (sc_fifo_0_out_startofpacket),           //          .startofpacket
		.out_endofpacket   (sc_fifo_0_out_endofpacket),             //          .endofpacket
		.out_empty         (sc_fifo_0_out_empty),                   //          .empty
		.almost_full_data  (),                                      // (terminated)
		.almost_empty_data (),                                      // (terminated)
		.in_error          (1'b0),                                  // (terminated)
		.out_error         (),                                      // (terminated)
		.in_channel        (1'b0),                                  // (terminated)
		.out_channel       ()                                       // (terminated)
	);

	altera_avalon_sc_fifo #(
		.SYMBOLS_PER_BEAT    (4),
		.BITS_PER_SYMBOL     (8),
		.FIFO_DEPTH          (256),
		.CHANNEL_WIDTH       (0),
		.ERROR_WIDTH         (0),
		.USE_PACKETS         (1),
		.USE_FILL_LEVEL      (1),
		.EMPTY_LATENCY       (3),
		.USE_MEMORY_BLOCKS   (1),
		.USE_STORE_FORWARD   (1),
		.USE_ALMOST_FULL_IF  (0),
		.USE_ALMOST_EMPTY_IF (0)
	) sc_fifo_1 (
		.clk               (clk_clk),                                   //       clk.clk
		.reset             (rst_controller_reset_out_reset),            // clk_reset.reset
		.csr_address       (),                                          //       csr.address
		.csr_read          (),                                          //          .read
		.csr_write         (),                                          //          .write
		.csr_readdata      (),                                          //          .readdata
		.csr_writedata     (),                                          //          .writedata
		.in_data           (avalon_st_adapter_003_out_0_data),          //        in.data
		.in_valid          (avalon_st_adapter_003_out_0_valid),         //          .valid
		.in_ready          (avalon_st_adapter_003_out_0_ready),         //          .ready
		.in_startofpacket  (avalon_st_adapter_003_out_0_startofpacket), //          .startofpacket
		.in_endofpacket    (avalon_st_adapter_003_out_0_endofpacket),   //          .endofpacket
		.in_empty          (avalon_st_adapter_003_out_0_empty),         //          .empty
		.out_data          (sc_fifo_1_out_data),                        //       out.data
		.out_valid         (sc_fifo_1_out_valid),                       //          .valid
		.out_ready         (sc_fifo_1_out_ready),                       //          .ready
		.out_startofpacket (sc_fifo_1_out_startofpacket),               //          .startofpacket
		.out_endofpacket   (sc_fifo_1_out_endofpacket),                 //          .endofpacket
		.out_empty         (sc_fifo_1_out_empty),                       //          .empty
		.almost_full_data  (),                                          // (terminated)
		.almost_empty_data (),                                          // (terminated)
		.in_error          (1'b0),                                      // (terminated)
		.out_error         (),                                          // (terminated)
		.in_channel        (1'b0),                                      // (terminated)
		.out_channel       ()                                           // (terminated)
	);

	st_64_inv st_64_inv_0 (
		.avalon_streaming_source_data          (st_64_inv_0_avalon_streaming_source_data),          // avalon_streaming_source.data
		.avalon_streaming_source_endofpacket   (st_64_inv_0_avalon_streaming_source_endofpacket),   //                        .endofpacket
		.avalon_streaming_source_ready         (st_64_inv_0_avalon_streaming_source_ready),         //                        .ready
		.avalon_streaming_source_startofpacket (st_64_inv_0_avalon_streaming_source_startofpacket), //                        .startofpacket
		.avalon_streaming_source_valid         (st_64_inv_0_avalon_streaming_source_valid),         //                        .valid
		.avalon_streaming_sink_data            (st_source_bfm_0_src_data),                          // avalon_streaming_sink_1.data
		.avalon_streaming_sink_ready           (st_source_bfm_0_src_ready),                         //                        .ready
		.avalon_streaming_sink_endofpacket     (st_source_bfm_0_src_endofpacket),                   //                        .endofpacket
		.avalon_streaming_sink_startofpacket   (st_source_bfm_0_src_startofpacket),                 //                        .startofpacket
		.avalon_streaming_sink_valid           (st_source_bfm_0_src_valid),                         //                        .valid
		.clock_clk                             (clk_clk),                                           //                   clock.clk
		.reset_reset                           (rst_controller_reset_out_reset)                     //                   reset.reset
	);

	altera_avalon_st_sink_bfm #(
		.USE_PACKET       (1),
		.USE_CHANNEL      (0),
		.USE_ERROR        (0),
		.USE_READY        (1),
		.USE_VALID        (1),
		.USE_EMPTY        (0),
		.ST_SYMBOL_W      (8),
		.ST_NUMSYMBOLS    (4),
		.ST_CHANNEL_W     (1),
		.ST_ERROR_W       (1),
		.ST_EMPTY_W       (2),
		.ST_READY_LATENCY (0),
		.ST_BEATSPERCYCLE (1),
		.ST_MAX_CHANNELS  (1),
		.VHDL_ID          (0)
	) st_sink_bfm_0 (
		.clk                (clk_clk),                                   //       clk.clk
		.reset              (rst_controller_reset_out_reset),            // clk_reset.reset
		.sink_data          (avalon_st_adapter_002_out_0_data),          //      sink.data
		.sink_valid         (avalon_st_adapter_002_out_0_valid),         //          .valid
		.sink_ready         (avalon_st_adapter_002_out_0_ready),         //          .ready
		.sink_startofpacket (avalon_st_adapter_002_out_0_startofpacket), //          .startofpacket
		.sink_endofpacket   (avalon_st_adapter_002_out_0_endofpacket),   //          .endofpacket
		.sink_empty         (2'b00),                                     // (terminated)
		.sink_channel       (1'b0),                                      // (terminated)
		.sink_error         (1'b0)                                       // (terminated)
	);

	altera_avalon_st_source_bfm #(
		.USE_PACKET       (1),
		.USE_CHANNEL      (0),
		.USE_ERROR        (0),
		.USE_READY        (1),
		.USE_VALID        (1),
		.USE_EMPTY        (0),
		.ST_SYMBOL_W      (8),
		.ST_NUMSYMBOLS    (4),
		.ST_CHANNEL_W     (1),
		.ST_ERROR_W       (1),
		.ST_EMPTY_W       (2),
		.ST_READY_LATENCY (0),
		.ST_BEATSPERCYCLE (1),
		.ST_MAX_CHANNELS  (1),
		.VHDL_ID          (0)
	) st_source_bfm_0 (
		.clk               (clk_clk),                           //       clk.clk
		.reset             (rst_controller_reset_out_reset),    // clk_reset.reset
		.src_data          (st_source_bfm_0_src_data),          //       src.data
		.src_valid         (st_source_bfm_0_src_valid),         //          .valid
		.src_ready         (st_source_bfm_0_src_ready),         //          .ready
		.src_startofpacket (st_source_bfm_0_src_startofpacket), //          .startofpacket
		.src_endofpacket   (st_source_bfm_0_src_endofpacket),   //          .endofpacket
		.src_empty         (),                                  // (terminated)
		.src_channel       (),                                  // (terminated)
		.src_error         ()                                   // (terminated)
	);

	turbo_sim_avalon_st_adapter #(
		.inBitsPerSymbol (8),
		.inUsePackets    (1),
		.inDataWidth     (32),
		.inChannelWidth  (0),
		.inErrorWidth    (0),
		.inUseEmptyPort  (0),
		.inUseValid      (1),
		.inUseReady      (1),
		.inReadyLatency  (0),
		.outDataWidth    (32),
		.outChannelWidth (0),
		.outErrorWidth   (0),
		.outUseEmptyPort (1),
		.outUseValid     (1),
		.outUseReady     (1),
		.outReadyLatency (0)
	) avalon_st_adapter (
		.in_clk_0_clk        (clk_clk),                                           // in_clk_0.clk
		.in_rst_0_reset      (rst_controller_reset_out_reset),                    // in_rst_0.reset
		.in_0_data           (st_64_inv_0_avalon_streaming_source_data),          //     in_0.data
		.in_0_valid          (st_64_inv_0_avalon_streaming_source_valid),         //         .valid
		.in_0_ready          (st_64_inv_0_avalon_streaming_source_ready),         //         .ready
		.in_0_startofpacket  (st_64_inv_0_avalon_streaming_source_startofpacket), //         .startofpacket
		.in_0_endofpacket    (st_64_inv_0_avalon_streaming_source_endofpacket),   //         .endofpacket
		.out_0_data          (avalon_st_adapter_out_0_data),                      //    out_0.data
		.out_0_valid         (avalon_st_adapter_out_0_valid),                     //         .valid
		.out_0_ready         (avalon_st_adapter_out_0_ready),                     //         .ready
		.out_0_startofpacket (avalon_st_adapter_out_0_startofpacket),             //         .startofpacket
		.out_0_endofpacket   (avalon_st_adapter_out_0_endofpacket),               //         .endofpacket
		.out_0_empty         (avalon_st_adapter_out_0_empty)                      //         .empty
	);

	turbo_sim_avalon_st_adapter_001 #(
		.inBitsPerSymbol (8),
		.inUsePackets    (1),
		.inDataWidth     (32),
		.inChannelWidth  (0),
		.inErrorWidth    (0),
		.inUseEmptyPort  (1),
		.inUseValid      (1),
		.inUseReady      (1),
		.inReadyLatency  (0),
		.outDataWidth    (32),
		.outChannelWidth (0),
		.outErrorWidth   (0),
		.outUseEmptyPort (0),
		.outUseValid     (1),
		.outUseReady     (1),
		.outReadyLatency (0)
	) avalon_st_adapter_001 (
		.in_clk_0_clk        (clk_clk),                                   // in_clk_0.clk
		.in_rst_0_reset      (rst_controller_reset_out_reset),            // in_rst_0.reset
		.in_0_data           (sc_fifo_0_out_data),                        //     in_0.data
		.in_0_valid          (sc_fifo_0_out_valid),                       //         .valid
		.in_0_ready          (sc_fifo_0_out_ready),                       //         .ready
		.in_0_startofpacket  (sc_fifo_0_out_startofpacket),               //         .startofpacket
		.in_0_endofpacket    (sc_fifo_0_out_endofpacket),                 //         .endofpacket
		.in_0_empty          (sc_fifo_0_out_empty),                       //         .empty
		.out_0_data          (avalon_st_adapter_001_out_0_data),          //    out_0.data
		.out_0_valid         (avalon_st_adapter_001_out_0_valid),         //         .valid
		.out_0_ready         (avalon_st_adapter_001_out_0_ready),         //         .ready
		.out_0_startofpacket (avalon_st_adapter_001_out_0_startofpacket), //         .startofpacket
		.out_0_endofpacket   (avalon_st_adapter_001_out_0_endofpacket)    //         .endofpacket
	);

	turbo_sim_avalon_st_adapter_001 #(
		.inBitsPerSymbol (8),
		.inUsePackets    (1),
		.inDataWidth     (32),
		.inChannelWidth  (0),
		.inErrorWidth    (0),
		.inUseEmptyPort  (1),
		.inUseValid      (1),
		.inUseReady      (1),
		.inReadyLatency  (0),
		.outDataWidth    (32),
		.outChannelWidth (0),
		.outErrorWidth   (0),
		.outUseEmptyPort (0),
		.outUseValid     (1),
		.outUseReady     (1),
		.outReadyLatency (0)
	) avalon_st_adapter_002 (
		.in_clk_0_clk        (clk_clk),                                   // in_clk_0.clk
		.in_rst_0_reset      (rst_controller_reset_out_reset),            // in_rst_0.reset
		.in_0_data           (sc_fifo_1_out_data),                        //     in_0.data
		.in_0_valid          (sc_fifo_1_out_valid),                       //         .valid
		.in_0_ready          (sc_fifo_1_out_ready),                       //         .ready
		.in_0_startofpacket  (sc_fifo_1_out_startofpacket),               //         .startofpacket
		.in_0_endofpacket    (sc_fifo_1_out_endofpacket),                 //         .endofpacket
		.in_0_empty          (sc_fifo_1_out_empty),                       //         .empty
		.out_0_data          (avalon_st_adapter_002_out_0_data),          //    out_0.data
		.out_0_valid         (avalon_st_adapter_002_out_0_valid),         //         .valid
		.out_0_ready         (avalon_st_adapter_002_out_0_ready),         //         .ready
		.out_0_startofpacket (avalon_st_adapter_002_out_0_startofpacket), //         .startofpacket
		.out_0_endofpacket   (avalon_st_adapter_002_out_0_endofpacket)    //         .endofpacket
	);

	turbo_sim_avalon_st_adapter #(
		.inBitsPerSymbol (8),
		.inUsePackets    (1),
		.inDataWidth     (32),
		.inChannelWidth  (0),
		.inErrorWidth    (0),
		.inUseEmptyPort  (0),
		.inUseValid      (1),
		.inUseReady      (1),
		.inReadyLatency  (0),
		.outDataWidth    (32),
		.outChannelWidth (0),
		.outErrorWidth   (0),
		.outUseEmptyPort (1),
		.outUseValid     (1),
		.outUseReady     (1),
		.outReadyLatency (0)
	) avalon_st_adapter_003 (
		.in_clk_0_clk        (clk_clk),                                   // in_clk_0.clk
		.in_rst_0_reset      (rst_controller_reset_out_reset),            // in_rst_0.reset
		.in_0_data           (asic_avalon_0_source_data),                 //     in_0.data
		.in_0_valid          (asic_avalon_0_source_valid),                //         .valid
		.in_0_ready          (asic_avalon_0_source_ready),                //         .ready
		.in_0_startofpacket  (asic_avalon_0_source_startofpacket),        //         .startofpacket
		.in_0_endofpacket    (asic_avalon_0_source_endofpacket),          //         .endofpacket
		.out_0_data          (avalon_st_adapter_003_out_0_data),          //    out_0.data
		.out_0_valid         (avalon_st_adapter_003_out_0_valid),         //         .valid
		.out_0_ready         (avalon_st_adapter_003_out_0_ready),         //         .ready
		.out_0_startofpacket (avalon_st_adapter_003_out_0_startofpacket), //         .startofpacket
		.out_0_endofpacket   (avalon_st_adapter_003_out_0_endofpacket),   //         .endofpacket
		.out_0_empty         (avalon_st_adapter_003_out_0_empty)          //         .empty
	);

	altera_reset_controller #(
		.NUM_RESET_INPUTS          (1),
		.OUTPUT_RESET_SYNC_EDGES   ("deassert"),
		.SYNC_DEPTH                (2),
		.RESET_REQUEST_PRESENT     (0),
		.RESET_REQ_WAIT_TIME       (1),
		.MIN_RST_ASSERTION_TIME    (3),
		.RESET_REQ_EARLY_DSRT_TIME (1),
		.USE_RESET_REQUEST_IN0     (0),
		.USE_RESET_REQUEST_IN1     (0),
		.USE_RESET_REQUEST_IN2     (0),
		.USE_RESET_REQUEST_IN3     (0),
		.USE_RESET_REQUEST_IN4     (0),
		.USE_RESET_REQUEST_IN5     (0),
		.USE_RESET_REQUEST_IN6     (0),
		.USE_RESET_REQUEST_IN7     (0),
		.USE_RESET_REQUEST_IN8     (0),
		.USE_RESET_REQUEST_IN9     (0),
		.USE_RESET_REQUEST_IN10    (0),
		.USE_RESET_REQUEST_IN11    (0),
		.USE_RESET_REQUEST_IN12    (0),
		.USE_RESET_REQUEST_IN13    (0),
		.USE_RESET_REQUEST_IN14    (0),
		.USE_RESET_REQUEST_IN15    (0),
		.ADAPT_RESET_REQUEST       (0)
	) rst_controller (
		.reset_in0      (~reset_reset_n),                 // reset_in0.reset
		.clk            (clk_clk),                        //       clk.clk
		.reset_out      (rst_controller_reset_out_reset), // reset_out.reset
		.reset_req      (),                               // (terminated)
		.reset_req_in0  (1'b0),                           // (terminated)
		.reset_in1      (1'b0),                           // (terminated)
		.reset_req_in1  (1'b0),                           // (terminated)
		.reset_in2      (1'b0),                           // (terminated)
		.reset_req_in2  (1'b0),                           // (terminated)
		.reset_in3      (1'b0),                           // (terminated)
		.reset_req_in3  (1'b0),                           // (terminated)
		.reset_in4      (1'b0),                           // (terminated)
		.reset_req_in4  (1'b0),                           // (terminated)
		.reset_in5      (1'b0),                           // (terminated)
		.reset_req_in5  (1'b0),                           // (terminated)
		.reset_in6      (1'b0),                           // (terminated)
		.reset_req_in6  (1'b0),                           // (terminated)
		.reset_in7      (1'b0),                           // (terminated)
		.reset_req_in7  (1'b0),                           // (terminated)
		.reset_in8      (1'b0),                           // (terminated)
		.reset_req_in8  (1'b0),                           // (terminated)
		.reset_in9      (1'b0),                           // (terminated)
		.reset_req_in9  (1'b0),                           // (terminated)
		.reset_in10     (1'b0),                           // (terminated)
		.reset_req_in10 (1'b0),                           // (terminated)
		.reset_in11     (1'b0),                           // (terminated)
		.reset_req_in11 (1'b0),                           // (terminated)
		.reset_in12     (1'b0),                           // (terminated)
		.reset_req_in12 (1'b0),                           // (terminated)
		.reset_in13     (1'b0),                           // (terminated)
		.reset_req_in13 (1'b0),                           // (terminated)
		.reset_in14     (1'b0),                           // (terminated)
		.reset_req_in14 (1'b0),                           // (terminated)
		.reset_in15     (1'b0),                           // (terminated)
		.reset_req_in15 (1'b0)                            // (terminated)
	);

endmodule