module Alpha_razor2 #(parameter N = 5, parameter M = 6, parameter RazorBit = 1)
                     (input logic Clock,
                      input logic nReset,
                      input logic  signed [7:1][M-1:0] alpha_in_DFF, 
                      input logic  signed [N-1:0] ba2,
                      input logic  signed [M:0] ba1ba3,
                      input logic  signed [M:0] ba1ba2ba3,
                      output logic Error_current_Alpha,
                      output logic signed [7:1][M-1:0] alpha_out_DFF);
                     
// 12 Additions
logic signed [M+1:0] alpha_1_ba1ba2ba3;
logic signed [M+1:0] alpha_2_ba1ba3;
logic signed [M+1:0] alpha_3_ba2;
logic signed [M+1:0] alpha_4_ba2;
logic signed [M+1:0] alpha_5_ba1ba3;
logic signed [M+1:0] alpha_6_ba1ba2ba3;
// logic signed [M+1:0] alpha_0_ba1ba2ba3;
logic signed [M+1:0] alpha_2_ba2;
logic signed [M+1:0] alpha_3_ba1ba3;
logic signed [M+1:0] alpha_4_ba1ba3;
logic signed [M+1:0] alpha_5_ba2;
logic signed [M+1:0] alpha_7_ba1ba2ba3;

// Signed additions, no need to worry about sign extension
assign alpha_1_ba1ba2ba3 = $signed(alpha_in_DFF[1]) + $signed(ba1ba2ba3);
assign alpha_2_ba1ba3    = $signed(alpha_in_DFF[2]) + $signed(ba1ba3);
assign alpha_3_ba2       = $signed(alpha_in_DFF[3]) + $signed(ba2);
assign alpha_4_ba2       = $signed(alpha_in_DFF[4]) + $signed(ba2);
assign alpha_5_ba1ba3    = $signed(alpha_in_DFF[5]) + $signed(ba1ba3);
assign alpha_6_ba1ba2ba3 = $signed(alpha_in_DFF[6]) + $signed(ba1ba2ba3);
// assign alpha_0_ba1ba2ba3 = $signed(alpha_in_DFF[0]) + $signed(ba1ba2ba3);
assign alpha_2_ba2       = $signed(alpha_in_DFF[2]) + $signed(ba2);
assign alpha_3_ba1ba3    = $signed(alpha_in_DFF[3]) + $signed(ba1ba3);
assign alpha_4_ba1ba3    = $signed(alpha_in_DFF[4]) + $signed(ba1ba3);
assign alpha_5_ba2       = $signed(alpha_in_DFF[5]) + $signed(ba2);
assign alpha_7_ba1ba2ba3 = $signed(alpha_in_DFF[7]) + $signed(ba1ba2ba3);

// 8 MAX
logic signed [M+1:0] max1;
logic signed [M+1:0] max2;
logic signed [M+1:0] max3;
logic signed [M+1:0] max4;
logic signed [M+1:0] max5;
logic signed [M+1:0] max6;
logic signed [M+1:0] max7;
logic signed [M+1:0] max8;
assign max1 = $signed(0)                > (alpha_1_ba1ba2ba3)       ? $signed(0)                : (alpha_1_ba1ba2ba3);
assign max2 = alpha_2_ba1ba3            > alpha_3_ba2               ? alpha_2_ba1ba3            : alpha_3_ba2;
assign max3 = alpha_4_ba2               > alpha_5_ba1ba3            ? alpha_4_ba2               : alpha_5_ba1ba3;
assign max4 = $signed(alpha_in_DFF[7])  > alpha_6_ba1ba2ba3         ? $signed(alpha_in_DFF[7])  : alpha_6_ba1ba2ba3;
assign max5 = $signed(ba1ba2ba3)        > $signed(alpha_in_DFF[1])  ? $signed(ba1ba2ba3)        : $signed(alpha_in_DFF[1]);
assign max6 = alpha_2_ba2               > alpha_3_ba1ba3            ? alpha_2_ba2               : alpha_3_ba1ba3 ;
assign max7 = alpha_4_ba1ba3            > alpha_5_ba2               ? alpha_4_ba1ba3            : alpha_5_ba2;
assign max8 = $signed(alpha_in_DFF[6])  > alpha_7_ba1ba2ba3         ? $signed(alpha_in_DFF[6])  : alpha_7_ba1ba2ba3;

// Normalization through subtraction of alpha_i and alpha_0
// logic signed [M+2:0] alpha_out_ext0;
logic signed [M+2:0] alpha_out_ext1;
logic signed [M+2:0] alpha_out_ext2;
logic signed [M+2:0] alpha_out_ext3;
logic signed [M+2:0] alpha_out_ext4;
logic signed [M+2:0] alpha_out_ext5;
logic signed [M+2:0] alpha_out_ext6;
logic signed [M+2:0] alpha_out_ext7;

// assign alpha_out_ext0 = max1 - max1;
assign alpha_out_ext1 = max2 - max1;
assign alpha_out_ext2 = max3 - max1;
assign alpha_out_ext3 = max4 - max1;
assign alpha_out_ext4 = max5 - max1;
assign alpha_out_ext5 = max6 - max1;
assign alpha_out_ext6 = max7 - max1;
assign alpha_out_ext7 = max8 - max1;

logic signed [7:1][M-1:0] alpha_out_ff;
// BitClip #(.N_In(M+2), .N_Out(M)) Clip_alpha_0 (.IN(alpha_out_ext0),.OUT(alpha_out_ff[0]));
BitClip #(.N_In(M+3), .N_Out(M)) Clip_alpha_1 (.IN(alpha_out_ext1),.OUT(alpha_out_ff[1]));
BitClip #(.N_In(M+3), .N_Out(M)) Clip_alpha_2 (.IN(alpha_out_ext2),.OUT(alpha_out_ff[2]));
BitClip #(.N_In(M+3), .N_Out(M)) Clip_alpha_3 (.IN(alpha_out_ext3),.OUT(alpha_out_ff[3]));
BitClip #(.N_In(M+3), .N_Out(M)) Clip_alpha_4 (.IN(alpha_out_ext4),.OUT(alpha_out_ff[4]));
BitClip #(.N_In(M+3), .N_Out(M)) Clip_alpha_5 (.IN(alpha_out_ext5),.OUT(alpha_out_ff[5]));
BitClip #(.N_In(M+3), .N_Out(M)) Clip_alpha_6 (.IN(alpha_out_ext6),.OUT(alpha_out_ff[6]));
BitClip #(.N_In(M+3), .N_Out(M)) Clip_alpha_7 (.IN(alpha_out_ext7),.OUT(alpha_out_ff[7]));

// cadence async_set_reset "nReset"
always_ff@(posedge Clock, negedge nReset)
    if(!nReset)
    begin
        // alpha_out_DFF[0] <= 'b0;
        alpha_out_DFF[1] <= 'b0;
        alpha_out_DFF[2] <= 'b0;
        alpha_out_DFF[3] <= 'b0;
        alpha_out_DFF[4] <= 'b0;
        alpha_out_DFF[5] <= 'b0;
        alpha_out_DFF[6] <= 'b0;
        alpha_out_DFF[7] <= 'b0;
    end
    else 
    begin
        // alpha_out_DFF[0] <= alpha_out_ff[0];
        alpha_out_DFF[1] <= alpha_out_ff[1];
        alpha_out_DFF[2] <= alpha_out_ff[2];
        alpha_out_DFF[3] <= alpha_out_ff[3];
        alpha_out_DFF[4] <= alpha_out_ff[4];
        alpha_out_DFF[5] <= alpha_out_ff[5];
        alpha_out_DFF[6] <= alpha_out_ff[6];
        alpha_out_DFF[7] <= alpha_out_ff[7];
    end

// Latches to capture timing errors    
logic [7:1] alpha_out_LCH;
logic latch_enable;
assign latch_enable = Clock;
// cadence async_set_reset "nReset"
always_latch 
    if (!nReset)
    begin
            alpha_out_LCH[1] <= 'b0;
            alpha_out_LCH[2] <= 'b0;
            alpha_out_LCH[3] <= 'b0;
            alpha_out_LCH[4] <= 'b0;
            alpha_out_LCH[5] <= 'b0;
            alpha_out_LCH[6] <= 'b0;
            alpha_out_LCH[7] <= 'b0;
        end
    else 
    if (latch_enable)
        begin
            alpha_out_LCH[1] <= alpha_out_ff[1][M-RazorBit];
            alpha_out_LCH[2] <= alpha_out_ff[2][M-RazorBit];
            alpha_out_LCH[3] <= alpha_out_ff[3][M-RazorBit];
            alpha_out_LCH[4] <= alpha_out_ff[4][M-RazorBit];
            alpha_out_LCH[5] <= alpha_out_ff[5][M-RazorBit];
            alpha_out_LCH[6] <= alpha_out_ff[6][M-RazorBit];
            alpha_out_LCH[7] <= alpha_out_ff[7][M-RazorBit];
        end

// Error in the current section
assign Error_current_Alpha = (alpha_out_LCH[1] ^ alpha_out_DFF[1][M-RazorBit]) | 
                       (alpha_out_LCH[2] ^ alpha_out_DFF[2][M-RazorBit]) | 
                       (alpha_out_LCH[3] ^ alpha_out_DFF[3][M-RazorBit]) | 
                       (alpha_out_LCH[4] ^ alpha_out_DFF[4][M-RazorBit]) | 
                       (alpha_out_LCH[5] ^ alpha_out_DFF[5][M-RazorBit]) | 
                       (alpha_out_LCH[6] ^ alpha_out_DFF[6][M-RazorBit]) | 
                       (alpha_out_LCH[7] ^ alpha_out_DFF[7][M-RazorBit]) ;
                      
endmodule        
