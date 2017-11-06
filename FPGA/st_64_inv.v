// new_component.v

// This file was auto-generated as a prototype implementation of a module
// created in component editor.  It ties off all outputs to ground and
// ignores all inputs.  It needs to be edited to make it do something
// useful.
// 
// This file will not be automatically regenerated.  You should check it in
// to your version control system if you want to keep it.

`timescale 1 ps / 1 ps
module st_64_inv (
		input  wire        clock_clk,             //   clock.clk
		input  wire        reset_reset,           //   reset.reset
		input  wire [31:0] avalon_streaming_sink_data,            //   avalon_streaming_sink.data
		output wire        avalon_streaming_sink_ready,           //                        .ready
		input  wire        avalon_streaming_sink_endofpacket,     //                        .endofpacket
		input  wire        avalon_streaming_sink_startofpacket,   //                        .startofpacket
		input  wire        avalon_streaming_sink_valid,           //                        .valid
		output wire [31:0] avalon_streaming_source_data,          // avalon_streaming_source.data
		output wire        avalon_streaming_source_endofpacket,   //                        .endofpacket
		input  wire        avalon_streaming_source_ready,         //                        .ready
		output wire        avalon_streaming_source_startofpacket, //                        .startofpacket
		output wire        avalon_streaming_source_valid          //                        .valid
	);

	// TODO: Auto-generated HDL template

	assign avalon_streaming_sink_ready = avalon_streaming_source_ready;

	assign avalon_streaming_source_valid = avalon_streaming_sink_valid;

	assign avalon_streaming_source_data = avalon_streaming_sink_data;

	assign avalon_streaming_source_startofpacket = avalon_streaming_sink_data[24];

	assign avalon_streaming_source_endofpacket = avalon_streaming_sink_data[25];

endmodule
