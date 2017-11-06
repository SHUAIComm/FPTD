`timescale 1 ns / 1 ps

// console messaging level
`define VERBOSITY VERBOSITY_WARNING

//BFM hierachy
`define SRC u_bfm.st_source_bfm_0
`define SNK u_bfm.st_sink_bfm_0

`define SOURCE_RESP_TIMEOUT 500000


module tb_avalon_ASIC();

    import verbosity_pkg::*;
    import data_pkg::*;

    parameter DATAPATH_WIDTH = 32;  
    parameter ENABLE_DELAY = 1;

    localparam HEADER_WIDTH = 0;   
    localparam DATA_WIDTH = DATAPATH_WIDTH +(8-DATAPATH_WIDTH)%8;

    logic                                       ASIC_nReset;
    logic                                       ASIC_Clock;
    logic                                       ASIC_Go;
    logic                                       ASIC_Mode;
    logic                                       ASIC_Enable_f;
    logic                                       ASIC_Sel_f;
    logic                                       ASIC_S1;
    logic                                       ASIC_S2;
    logic                                       ASIC_S3;
    logic       [6:0]                           ASIC_In;
    logic       [6:0]                           ASIC_DOut1;
    logic       [6:0]                           ASIC_DOut2;
    logic       [6:0]                           ASIC_TOut;
    logic                                       ASIC_bitout1;
    logic                                       ASIC_bitout2;
    logic                                       ASIC_KeepShift;
    logic                                       ASIC_Start;
    logic                                       ASIC_Start2;
    logic                                       ASIC_TestReady;
    logic                                       ASIC_Dclk;

    logic switch_fpga_asic;
    logic TestMode;
    logic Enable_f;
    logic Sel_f;
    logic S1;
    logic S2;
    logic S3;
    
    logic clk, resetn;
    logic start;
    logic [6:0] error;
    logic [6:0] error_count;
    logic [6:0] Tout;
    logic bitout;
    logic keepshift;
    logic TestReady;
    

    // declare class object from data_pkg
    // class for read matlab data
    read_file #(.WIDTH(DATAPATH_WIDTH)) reading = new;
    // class for avalon interface package data
    avalon_st_data #(
        .HEADER_WIDTH(HEADER_WIDTH),
        .DATA_IN_WIDTH(DATA_WIDTH),
        .DATA_OUT_WIDTH(DATA_WIDTH)
    ) avalon_st = new;

    logic   [DATA_WIDTH-1:0]    data_in;

    int outputting, output_data_receive, input_data_available;
    int sop, eop;
    int data_in_count;
    int data_out_count;
    int final_error;
    
    initial begin
        clk = 0;
        resetn = 0;      
        #30;
        resetn = 1;
    end

    default clocking test @ (posedge clk);
    endclocking

    always
        #10 clk = ~clk;

    initial begin
        set_verbosity(`VERBOSITY);

        `SRC.set_response_timeout(`SOURCE_RESP_TIMEOUT);
        `SRC.init();

        #30;
        while (resetn == 0)
            #10;
        ##10;
        output_data_receive = 0;

        `SNK.set_ready(1);
        while(outputting) begin
            @ (`SNK.signal_transaction_received);            
            // get data from BFM and set to output package
            snk_pop_transaction();
            output_data_receive = 1;
        end
    end
    
    initial begin   
        while(1) begin
            ##1;
            if((($urandom & 4'hF) > 8) && (ENABLE_DELAY==1))
                `SNK.set_ready(1'b0);
            else
                `SNK.set_ready(1'b1);
            ## ($urandom%5);
            `SNK.set_ready(1'b1);
        end   
    end

    always @(*) begin
        if(input_data_available) begin
            // push data to BFM
            src_pushing_transaction();
        end
    end
    
    always @(avalon_st.SNK) begin
        TestReady = avalon_st.SNK.data[29];
        start = avalon_st.SNK.data[27];
        keepshift = avalon_st.SNK.data[26];
        bitout = avalon_st.SNK.data[24];
        Tout = avalon_st.SNK.data[22:16];
        error = avalon_st.SNK.data[6:0];
    end
    
    initial begin
        switch_fpga_asic = 1;
        TestMode = 0;
        Enable_f = 0;
        Sel_f = 0;
        S1 = 0;
        S2 = 0; 
        S3 = 0;
        data_out_count = 0;
        while(1) begin
            if(output_data_receive) begin
                if(avalon_st.SNK.startofpacket) begin
                    error_count = 0;
                    data_out_count = 0;
                end
                else if(keepshift & bitout)
                    error_count = error_count+1;
                if(data_out_count==3)
                    final_error = error;
                data_out_count++;
                output_data_receive = 0;
                
                // if(TestMode==0)
                    // $display("%0x", Tout);
                
                if(avalon_st.SNK.endofpacket & TestMode==1)
                    if(final_error==error_count)
                        $display("Result match, error is %0d", final_error);
                    else
                        $display("Result not match, %0d != %0d", final_error, error_count);
            end
            ##1;
        end
    end
    
   
    initial begin
        sop = 0;
        eop = 0;
        data_in_count = 0;

        #30;
        while (resetn == 0)
            #10;
        ##10;

        while(1) begin
            //sometimes delay a few cycles before providing more data
            if((($urandom & 4'hF) > 10) && (ENABLE_DELAY==1))
               ## ($urandom%5);
        
            if(data_in_count==0)
                sop = 1;
            else if(data_in_count==201)
                eop = 1;
            data_in = 0;
            data_in[6:0] = sop | data_in_count<2 ? 0 : $urandom;
            data_in[8] = sop ? 1'b0 : 1'b1;
            data_in[9] = S3;
            data_in[10] = S2;
            data_in[11] = S1;
            data_in[12] = Sel_f;
            data_in[13] = Enable_f;
            data_in[14] = TestMode;

            data_in[24] = sop;
            data_in[25] = eop;
            
            // set data to input package
            avalon_st.set_src_transaction(
                .idles(0),
                .data(data_in),
                .channel(1),
                .error(0),
                .empty(0),
                .startofpacket(sop),
                .endofpacket(eop)
            );
            input_data_available = 1;   
            data_in_count++;
            if(data_in_count==202)
                data_in_count = 0;
            
            ##1;
            input_data_available = 0;
            sop = 0;
            if(eop) begin
                eop = 0;
                if((($urandom & 4'hF) > 10) && (ENABLE_DELAY==1))
                    ## 5000;
            end
        end

    end
    
    initial begin

        #30;
        while (resetn == 0)
            #10;
        ##10;

        outputting = 1;

    end
 
  
    //functions

    //push the transaction to Source BFM queue
    function automatic void src_pushing_transaction(
    );
        `SRC.set_transaction_idles   (avalon_st.SRC.idles);
        `SRC.set_transaction_sop     (avalon_st.SRC.startofpacket);
        `SRC.set_transaction_eop     (avalon_st.SRC.endofpacket);
        // `SRC.set_transaction_channel (avalon_st.SRC.channel);
        `SRC.set_transaction_data    (avalon_st.SRC.data);
        `SRC.set_transaction_error   (avalon_st.SRC.error);    
        `SRC.set_transaction_empty   (avalon_st.SRC.empty);    
        `SRC.push_transaction();  
    endfunction
  
    //pop the transaction from Sink BFM queue and get the decriptors
    function automatic void snk_pop_transaction(
    );
        `SNK.pop_transaction();    
        avalon_st.set_snk_transaction
        (
            .idles(`SNK.get_transaction_idles()),
            .startofpacket(`SNK.get_transaction_sop()),
            .endofpacket(`SNK.get_transaction_eop()),
            .channel(`SNK.get_transaction_channel()),
            .data(`SNK.get_transaction_data()),
            .error(`SNK.get_transaction_error()),
            .empty(`SNK.get_transaction_empty())
        );
    endfunction
  
   turbo_sim u_bfm (
		.clk_clk       (clk),       //   clk.clk
		.reset_reset_n (resetn),  // reset.reset_n
        
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
        .asic_avalon_0_asic_switch_fpga_asic_data(switch_fpga_asic),
        .asic_avalon_0_asic_testready_data(ASIC_TestReady),       
        .asic_avalon_0_asic_tout_data(ASIC_TOut)
	);
      
endmodule
