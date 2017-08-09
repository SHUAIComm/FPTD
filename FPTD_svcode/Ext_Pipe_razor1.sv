module Ext_Pipe_razor1 #(parameter N = 5, parameter M = 6, parameter RazorBit = 1)
                        (input logic Clock,
                         input logic nReset,
                         input logic nClear,
                         input logic Enable,
                         input logic Error_previous_Epsilon,
                         input logic signed [N-1:0] ba2,       
						 input logic signed [4:1][M:0] epsilon, 
                         output logic Error_current_be1,
                         output logic signed [M-1:0] be1_DFF);
 
logic signed [M+1:0] epsilon2_ba2;
logic signed [M+1:0] epsilon4_ba2;
assign epsilon2_ba2 = $signed(epsilon[2]) + ba2;/* Changed by Andy */
assign epsilon4_ba2 = $signed(epsilon[4]) + ba2;/* Changed by Andy */

// Third layer of MAX operations
logic signed [M+1:0] A;
logic signed [M+1:0] B;
 
assign A = $signed(epsilon[1]) > epsilon2_ba2 ? $signed(epsilon[1]) : epsilon2_ba2;/* Changed by Andy */
assign B = $signed(epsilon[3]) > epsilon4_ba2 ? $signed(epsilon[3]) : epsilon4_ba2;/* Changed by Andy */

// Subtract B - A
logic signed [M+2:0] B_minus_A;
logic signed [M-1:0] be1_ff;
assign B_minus_A = B - A;

BitClip #(.N_In(M+3), .N_Out(M)) Clip_Ext (.IN(B_minus_A),.OUT(be1_ff));

// cadence async_set_reset "nReset"
always_ff@(posedge Clock, negedge nReset, negedge nClear)
    if(!nReset || !nClear)
        be1_DFF <= 'b0;
    else if(Enable && !Error_previous_Epsilon)
        be1_DFF <= be1_ff;

// Latches to capture timing errors
logic be1_LCH;
logic latch_enable;

assign latch_enable = !Enable && !Error_previous_Epsilon && Clock;
// cadence async_set_reset "nReset"
always_latch
    if(!nReset || !nClear)
        be1_LCH <= 'b0;
    else 
    if (latch_enable)
        be1_LCH <= be1_ff[M-RazorBit];
// Error in the current section
assign Error_current_be1 = be1_LCH ^ be1_DFF[M-RazorBit]; 
        
        
endmodule
