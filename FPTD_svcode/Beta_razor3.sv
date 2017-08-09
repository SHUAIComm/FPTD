module Beta_razor3 #(parameter N = 5, parameter M = 6, parameter RazorBit = 1)
                    (input logic Clock,
                     input logic nReset,
                     input logic signed [7:1][M-1:0] beta_in_DFF, 
                     input logic signed [N-1:0] ba2,
                     input logic signed [M:0] ba1ba3,
                     input logic signed [M:0] ba1ba2ba3,
                     output logic Error_current_Beta,
                     output logic signed [7:1][M-1:0] beta_out_TrueQ);
                     
// 12 Additions
logic signed [M+1:0] beta_4_ba1ba2ba3;
// logic signed [M+1:0] beta_0_ba1ba2ba3;
logic signed [M+1:0] beta_1_ba1ba3;
logic signed [M+1:0] beta_5_ba2;
logic signed [M+1:0] beta_1_ba2;
logic signed [M+1:0] beta_5_ba1ba3;
logic signed [M+1:0] beta_2_ba2;
logic signed [M+1:0] beta_6_ba1ba3;
logic signed [M+1:0] beta_2_ba1ba3;
logic signed [M+1:0] beta_6_ba2;
logic signed [M+1:0] beta_3_ba1ba2ba3;
logic signed [M+1:0] beta_7_ba1ba2ba3;

// Signed additions, no need to worry about sign extension
assign beta_4_ba1ba2ba3 = $signed(beta_in_DFF[4]) + $signed(ba1ba2ba3);
// assign beta_0_ba1ba2ba3 = $signed(beta_in_DFF[0]) + $signed(ba1ba2ba3);
assign beta_1_ba1ba3   = $signed(beta_in_DFF[1]) + $signed(ba1ba3);
assign beta_5_ba2     = $signed(beta_in_DFF[5]) + $signed(ba2);
assign beta_1_ba2     = $signed(beta_in_DFF[1]) + $signed(ba2);
assign beta_5_ba1ba3   = $signed(beta_in_DFF[5]) + $signed(ba1ba3);
assign beta_2_ba2     = $signed(beta_in_DFF[2]) + $signed(ba2);
assign beta_6_ba1ba3   = $signed(beta_in_DFF[6]) + $signed(ba1ba3);
assign beta_2_ba1ba3   = $signed(beta_in_DFF[2]) + $signed(ba1ba3);
assign beta_6_ba2     = $signed(beta_in_DFF[6]) + $signed(ba2);
assign beta_3_ba1ba2ba3 = $signed(beta_in_DFF[3]) + $signed(ba1ba2ba3);
assign beta_7_ba1ba2ba3 = $signed(beta_in_DFF[7]) + $signed(ba1ba2ba3);

// 8 MAX
logic signed [M+1:0] max1;
logic signed [M+1:0] max2;
logic signed [M+1:0] max3;
logic signed [M+1:0] max4;
logic signed [M+1:0] max5;
logic signed [M+1:0] max6;
logic signed [M+1:0] max7;
logic signed [M+1:0] max8;
assign max1 = $signed(0)              > beta_4_ba1ba2ba3        ? $signed(0)              : beta_4_ba1ba2ba3;
assign max2 = ba1ba2ba3               > $signed(beta_in_DFF[4]) ? ba1ba2ba3               : $signed(beta_in_DFF[4]);
assign max3 = beta_1_ba1ba3           > beta_5_ba2              ? beta_1_ba1ba3           : beta_5_ba2;
assign max4 = beta_1_ba2              > beta_5_ba1ba3           ? beta_1_ba2              : beta_5_ba1ba3;
assign max5 = beta_2_ba2              > beta_6_ba1ba3           ? beta_2_ba2              : beta_6_ba1ba3;
assign max6 = beta_2_ba1ba3           > beta_6_ba2              ? beta_2_ba1ba3           : beta_6_ba2 ;
assign max7 = beta_3_ba1ba2ba3        > $signed(beta_in_DFF[7]) ? beta_3_ba1ba2ba3        : $signed(beta_in_DFF[7]);
assign max8 = $signed(beta_in_DFF[3]) > beta_7_ba1ba2ba3        ? $signed(beta_in_DFF[3]) : beta_7_ba1ba2ba3;

// Normalization through subtraction of beta_i and beta_0
// logic signed [M+1:0] beta_out_ext0;
logic signed [M+2:0] beta_out_ext1;
logic signed [M+2:0] beta_out_ext2;
logic signed [M+2:0] beta_out_ext3;
logic signed [M+2:0] beta_out_ext4;
logic signed [M+2:0] beta_out_ext5;
logic signed [M+2:0] beta_out_ext6;
logic signed [M+2:0] beta_out_ext7;
// assign beta_out_ext0 = max1 - max1;
assign beta_out_ext1 = max2 - max1;
assign beta_out_ext2 = max3 - max1;
assign beta_out_ext3 = max4 - max1;
assign beta_out_ext4 = max5 - max1;
assign beta_out_ext5 = max6 - max1;
assign beta_out_ext6 = max7 - max1;
assign beta_out_ext7 = max8 - max1;

logic signed [7:1][M-1:0] beta_out_ff;
// BitClip #(.N_In(M+2), .N_Out(M)) Clip_beta_0 (.IN(beta_out_ext0),.OUT(beta_out_ff[0]));
BitClip #(.N_In(M+3), .N_Out(M)) Clip_beta_1 (.IN(beta_out_ext1),.OUT(beta_out_ff[1]));
BitClip #(.N_In(M+3), .N_Out(M)) Clip_beta_2 (.IN(beta_out_ext2),.OUT(beta_out_ff[2]));
BitClip #(.N_In(M+3), .N_Out(M)) Clip_beta_3 (.IN(beta_out_ext3),.OUT(beta_out_ff[3]));
BitClip #(.N_In(M+3), .N_Out(M)) Clip_beta_4 (.IN(beta_out_ext4),.OUT(beta_out_ff[4]));
BitClip #(.N_In(M+3), .N_Out(M)) Clip_beta_5 (.IN(beta_out_ext5),.OUT(beta_out_ff[5]));
BitClip #(.N_In(M+3), .N_Out(M)) Clip_beta_6 (.IN(beta_out_ext6),.OUT(beta_out_ff[6]));
BitClip #(.N_In(M+3), .N_Out(M)) Clip_beta_7 (.IN(beta_out_ext7),.OUT(beta_out_ff[7]));

logic signed [7:1][M-1:0] beta_out_DFF;
// cadence infer_multibit "beta_out_DFF"
// cadence async_set_reset "nReset"
always_ff@(posedge Clock, negedge nReset)
    if(!nReset)
    begin
        // beta_out_DFF[0] <= 'b0;
        beta_out_DFF[1] <= 'b0;
        beta_out_DFF[2] <= 'b0;
        beta_out_DFF[3] <= 'b0;
        beta_out_DFF[4] <= 'b0;
        beta_out_DFF[5] <= 'b0;
        beta_out_DFF[6] <= 'b0;
        beta_out_DFF[7] <= 'b0;
    end
    else 
    begin
        // beta_out_DFF[0] <= beta_out_ff[0];
        beta_out_DFF[1] <= beta_out_ff[1];
        beta_out_DFF[2] <= beta_out_ff[2];
        beta_out_DFF[3] <= beta_out_ff[3];
        beta_out_DFF[4] <= beta_out_ff[4];
        beta_out_DFF[5] <= beta_out_ff[5];
        beta_out_DFF[6] <= beta_out_ff[6];
        beta_out_DFF[7] <= beta_out_ff[7];
    end

// Latches to capture timing errors    
logic [7:1] beta_out_LCH;
logic latch_enable;

assign latch_enable = Clock;
// cadence async_set_reset "nReset"
// cadence infer_multibit "beta_out_LCH"
assign latch_enable = Clock;
always_latch
    if (!nReset)
    begin
            beta_out_LCH[1] <= 'b0;
            beta_out_LCH[2] <= 'b0;
            beta_out_LCH[3] <= 'b0;
            beta_out_LCH[4] <= 'b0;
            beta_out_LCH[5] <= 'b0;
            beta_out_LCH[6] <= 'b0;
            beta_out_LCH[7] <= 'b0;
        end
    else 
    if (latch_enable)
        begin
            beta_out_LCH[1] <= beta_out_ff[1][M-RazorBit];
            beta_out_LCH[2] <= beta_out_ff[2][M-RazorBit];
            beta_out_LCH[3] <= beta_out_ff[3][M-RazorBit];
            beta_out_LCH[4] <= beta_out_ff[4][M-RazorBit];
            beta_out_LCH[5] <= beta_out_ff[5][M-RazorBit];
            beta_out_LCH[6] <= beta_out_ff[6][M-RazorBit];
            beta_out_LCH[7] <= beta_out_ff[7][M-RazorBit];
        end

// Error in the current section
assign Error_current_Beta = (beta_out_LCH[1] ^ beta_out_DFF[1][M-RazorBit]) | 
                       (beta_out_LCH[2] ^ beta_out_DFF[2][M-RazorBit]) | 
                       (beta_out_LCH[3] ^ beta_out_DFF[3][M-RazorBit]) | 
                       (beta_out_LCH[4] ^ beta_out_DFF[4][M-RazorBit]) | 
                       (beta_out_LCH[5] ^ beta_out_DFF[5][M-RazorBit]) | 
                       (beta_out_LCH[6] ^ beta_out_DFF[6][M-RazorBit]) | 
                       (beta_out_LCH[7] ^ beta_out_DFF[7][M-RazorBit]) ;
                       

generate 
genvar index_beta; 
    for(index_beta=1; index_beta<8; index_beta=index_beta+1)
        begin:GenTrueQBeta
            assign beta_out_TrueQ[index_beta][M-RazorBit] = Error_current_Beta ^ beta_out_DFF[index_beta][M-RazorBit] ;
            assign beta_out_TrueQ[index_beta][M-RazorBit-1:0] = beta_out_DFF[index_beta][M-RazorBit-1:0];
        end
        
    if(RazorBit ==2)
    begin:GenTrueQBeta2MSB
        for(index_beta=1; index_beta<8; index_beta=index_beta+1)
        begin
            assign beta_out_TrueQ[index_beta][M-1] = beta_out_DFF[index_beta][M-1];
        end  
    end  

endgenerate          
                      
endmodule      
