// Copyright 2017 AccelerComm Ltd. 
// All rights reserved.
// 
// This file may contain confidential or proprietary work. This 
// file is subject to the terms of the licence agreement, and 
// you may only use, distribute or modify this file according
// to the terms of the licence agreement.
//
// Create by Shida Zhong on 20/09/2017
//

`timescale 1ns / 1ns

`ifndef _DATA_PKG_
`define _DATA_PKG_

package data_pkg;

    // import verbosity_pkg::*;

    class read_file # (parameter WIDTH = 8);
    
        task read_single;
            input int file;
            output int value;
            int r;
            r = 1;
            r = $fscanf(file,"%d, ",value);
            if (r != 1) begin
                $error("File reading error");
                $stop();
            end
        endtask
        
        task read_single_eol;
            input int file;
            output int value;
            int r; r = 1;
            r = $fscanf(file,"%d\n",value);
            if (r != 1) begin
                $error("File reading error");
                $stop();
            end
        endtask
        
        task read_single_hex_eol;
            input int file;
            output logic [WIDTH-1:0] value;
            int r; r = 1;
            r = $fscanf(file,"%x\n",value);
            if (r != 1) begin
                $error("File reading error");
                $stop();
            end
        endtask
    
    endclass
    
    
    class avalon_st_data # (
        parameter HEADER_WIDTH = 16,
        parameter DATA_IN_WIDTH = 16,
        parameter DATA_OUT_WIDTH = 16
    );
        //BFM related parameters
        localparam ST_IN_WIDTH = HEADER_WIDTH + DATA_IN_WIDTH;
        localparam ST_OUT_WIDTH = HEADER_WIDTH + DATA_OUT_WIDTH;
        localparam ST_CHANNEL_W = 3;
        localparam ST_ERROR_W = 3;
        localparam ST_EMPTY_W = 2;
        localparam ST_READY_LATENCY = 0;
        localparam ST_MAX_CHANNELS = 7;
        
        typedef logic [ST_IN_WIDTH-1  :0]   AvalonSTDataIn_t;
        typedef logic [ST_OUT_WIDTH-1 :0]   AvalonSTDataOut_t;
        typedef logic [ST_CHANNEL_W-1 :0]   AvalonSTChannel_t;
        typedef logic [ST_EMPTY_W-1   :0]   AvalonSTEmpty_t;
        typedef logic [ST_ERROR_W-1   :0]   AvalonSTError_t;
        
        //the ST transaction is defined using SystemVerilog structure data type
        typedef struct 
        {
            int                 idles;  //idle is not part of Avalon ST signal, it is used in BFM only
            bit                 startofpacket;
            bit                 endofpacket;
            AvalonSTChannel_t   channel;
            AvalonSTDataIn_t    data;
            AvalonSTError_t     error;
            AvalonSTEmpty_t     empty;
        } transaction_input_struct;

        typedef struct 
        {
            int                 idles;  //idle is not part of Avalon ST signal, it is used in BFM only
            bit                 startofpacket;
            bit                 endofpacket;
            AvalonSTChannel_t   channel;
            AvalonSTDataOut_t   data;
            AvalonSTError_t     error;
            AvalonSTEmpty_t     empty;
        } transaction_output_struct;

        typedef enum int 
        {
            SOURCE,
            SINK
        } label_t;
        
        transaction_input_struct SRC;
        transaction_output_struct SNK;
        
        //functions
  
        //get the data to Source BFM
        function automatic void set_src_transaction(
            int                 idles,
            bit                 startofpacket,
            bit                 endofpacket,
            AvalonSTChannel_t   channel,
            AvalonSTDataIn_t    data,
            AvalonSTError_t     error,
            AvalonSTEmpty_t     empty
        );
            SRC.idles           = idles;
            SRC.startofpacket   = startofpacket;
            SRC.endofpacket     = endofpacket;
            SRC.channel         = channel;
            SRC.data            = data;
            SRC.error           = error;    
            SRC.empty           = empty;
        endfunction
        
        function automatic transaction_input_struct get_src_transaction();
            return SRC;
        endfunction
        
        //get the data from Sink BFM
        function automatic void set_snk_transaction(
            int                 idles,
            bit                 startofpacket,
            bit                 endofpacket,
            AvalonSTChannel_t   channel,
            AvalonSTDataOut_t   data,
            AvalonSTError_t     error,
            AvalonSTEmpty_t     empty
        );
            SNK.idles           = idles;
            SNK.startofpacket   = startofpacket;
            SNK.endofpacket     = endofpacket;
            SNK.channel         = channel;
            SNK.data            = data;
            SNK.error           = error;    
            SNK.empty           = empty;
        endfunction
        
        function automatic transaction_output_struct get_snk_transaction();
            return SNK;
        endfunction

        // //prints the transaction to simulator console
        // function automatic void print_transaction(
            // transaction_input_struct transaction, 
            // label_t label_name,  
            // int count
        // );
            // string message;
            // if (label_name == SOURCE)
            // $sformat(message, "%m: Source BFM: Send transaction %0d ", count);
            // else
            // $sformat(message, "%m: Sink BFM: Receive transaction %0d ", count);
            // print(VERBOSITY_INFO, message);                  
            // $sformat(message, "%m:   Data:     %0x", transaction.data);
            // print(VERBOSITY_INFO, message);                        
            // $sformat(message, "%m:   Idles:    %0d", transaction.idles);
            // print(VERBOSITY_INFO, message);                            
            // $sformat(message, "%m:   SOP:      %0x", transaction.startofpacket);
            // print(VERBOSITY_INFO, message);                            
            // $sformat(message, "%m:   EOP:      %0x", transaction.endofpacket);
            // print(VERBOSITY_INFO, message);                            
            // //$sformat(message, "%m:   Channel: %0d", transaction.channel);
            // //print(VERBOSITY_INFO, message);                            
            // $sformat(message, "%m:   Error:   %0x", transaction.error);
            // print(VERBOSITY_INFO, message);                            
            // $sformat(message, "%m:   Empty:   %0d", transaction.empty);
            // print(VERBOSITY_INFO, message);    
        // endfunction
        
    endclass
   
endpackage

`endif