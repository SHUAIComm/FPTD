module RowDecoder #(parameter FrameLength =  40, parameter N = 6, parameter M = 6)
                           (input logic Clock,
                            input logic nReset,
                            input logic signed [FrameLength+2:0][M-1:0] ba1,
                            input logic signed [FrameLength+2:0][N-1:0] ba2,
                            input logic signed [FrameLength-1:0][N-1:0] ba3,
                            output logic signed [FrameLength-1:0][M-1:0] be1);


                     
// logic Clock;
// logic ~Clock;                     

logic signed [FrameLength-1:0][7:1][M-1:0]alpha_in;  
logic signed [FrameLength-2:0][7:1][M-1:0]alpha_out;                     
logic signed [FrameLength+2:0][7:1][M-1:0]beta_in;                      
logic signed [FrameLength+2:1][7:1][M-1:0]beta_out;   

assign alpha_in[0][1] = $signed({1'b1,{(M-1){1'b0}}});
assign alpha_in[0][2] = $signed({1'b1,{(M-1){1'b0}}});
assign alpha_in[0][3] = $signed({1'b1,{(M-1){1'b0}}});
assign alpha_in[0][4] = $signed({1'b1,{(M-1){1'b0}}});
assign alpha_in[0][5] = $signed({1'b1,{(M-1){1'b0}}});
assign alpha_in[0][6] = $signed({1'b1,{(M-1){1'b0}}});
assign alpha_in[0][7] = $signed({1'b1,{(M-1){1'b0}}});

assign beta_in[FrameLength+2][1] = $signed({1'b1,{(M-1){1'b0}}});
assign beta_in[FrameLength+2][2] = $signed({1'b1,{(M-1){1'b0}}});
assign beta_in[FrameLength+2][3] = $signed({1'b1,{(M-1){1'b0}}});
assign beta_in[FrameLength+2][4] = $signed({1'b1,{(M-1){1'b0}}});
assign beta_in[FrameLength+2][5] = $signed({1'b1,{(M-1){1'b0}}});
assign beta_in[FrameLength+2][6] = $signed({1'b1,{(M-1){1'b0}}});
assign beta_in[FrameLength+2][7] = $signed({1'b1,{(M-1){1'b0}}});
 
// CLK_Gen_OddnEven 
// CLK_Gen_OddnEven (.Clock_Sys(Clock), 
                  // .nReset(nReset), 
                  // .Clock(Clock), 
                  // .~Clock(~Clock));
                  
generate
genvar sec_index;
    for(sec_index=0; sec_index<FrameLength+3; sec_index=sec_index+1)
    begin:Gen_Section
         
                 
        // Forward Recursion ALPHA
        if(sec_index<FrameLength-1) // alpha N is not necessary
        begin:ForwardRecursion  
            assign alpha_in[sec_index+1] = alpha_out[sec_index];                            
        end
        
        // Backward Recursion BETA
        if(sec_index<FrameLength+2)
        begin:BackwardRecursion
            assign beta_in[sec_index] = beta_out[sec_index+1];                           
        end
        // Instantiate individual sections 
        if(sec_index==0) // Instantiate First section; Betas not needed
        begin:Section_First
        Section_NoBeta_N4_M5
        Section         (.Clock(Clock),
                         .nReset(nReset),
                         .ba1(ba1[sec_index]),
                         .ba2(ba2[sec_index]),
                         .ba3(ba3[sec_index]),
                         .alpha_in(alpha_in[sec_index]), 
                         .beta_in(beta_in[sec_index]),
                         .alpha_out(alpha_out[sec_index]),
                         .be1(be1[sec_index]));
        end
        else if(sec_index==FrameLength-1) // Instantiate Last Section; Alphas not needed
        begin:Section_Last
        Section_NoAlpha_N4_M5
        Section         (.Clock(~Clock),
                         .nReset(nReset),
                         .ba1(ba1[sec_index]),
                         .ba2(ba2[sec_index]),
                         .ba3(ba3[sec_index]),
                         .alpha_in(alpha_in[sec_index]), 
                         .beta_in(beta_in[sec_index]),
                         .beta_out(beta_out[sec_index]),
                         .be1(be1[sec_index]));
        end
        else if(sec_index>=FrameLength) // Instantiate Termination Sections; Only Betas needed
        begin:Section_Term
        Section_Termination_N4_M5
        Section_Termination  (.Clock(Clock),
                              .nReset(nReset),
                              .ba1(ba1[sec_index]),
                              .ba2(ba2[sec_index]),
                              .beta_in(beta_in[sec_index]),
                              .beta_out(beta_out[sec_index]));
        end
        else if(sec_index%2==0) // Instantiate Even Section
        begin:Section
        Section_N4_M5
        Section  (.Clock(Clock),
                  .nReset(nReset),
                  .ba1(ba1[sec_index]),
                  .ba2(ba2[sec_index]),
                  .ba3(ba3[sec_index]),
                  .alpha_in(alpha_in[sec_index]), 
                  .beta_in(beta_in[sec_index]),
                  .alpha_out(alpha_out[sec_index]),
                  .beta_out(beta_out[sec_index]),
                  .be1(be1[sec_index]));
        end
        else    // Instantiate Odd Section
        begin:Section
        Section_N4_M5
        Section  (.Clock(~Clock),
                  .nReset(nReset),
                  .ba1(ba1[sec_index]),
                  .ba2(ba2[sec_index]),
                  .ba3(ba3[sec_index]),
                  .alpha_in(alpha_in[sec_index]), 
                  .beta_in(beta_in[sec_index]),
                  .alpha_out(alpha_out[sec_index]),
                  .beta_out(beta_out[sec_index]),
                  .be1(be1[sec_index]));
        end
    end
endgenerate
             
endmodule
