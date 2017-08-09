module Beta #(parameter N = 5, parameter M = 6)
             (input logic Clock,
              input logic nReset,
              input logic nClear,
              input logic Enable,
              input logic signed [7:1][M-1:0] beta_in, 
              input logic signed [N-1:0] ba2,
              input logic signed [M:0] ba1ba3,
              input logic signed [M:0] ba1ba2ba3,
              output logic signed [7:1][M-1:0] beta_out);
                     
// 12 Additions
logic signed [M+1:0] beta_4_ba1ba2ba3;
// logic signed [M:0] beta_0_ba1ba2ba3;
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
assign beta_4_ba1ba2ba3 = $signed(beta_in[4]) + $signed(ba1ba2ba3);
// assign beta_0_ba1ba2ba3 = $signed(beta_in[0]) + $signed(ba1ba2ba3);
assign beta_1_ba1ba3   = $signed(beta_in[1]) + $signed(ba1ba3);
assign beta_5_ba2     = $signed(beta_in[5]) + $signed(ba2);
assign beta_1_ba2     = $signed(beta_in[1]) + $signed(ba2);
assign beta_5_ba1ba3   = $signed(beta_in[5]) + $signed(ba1ba3);
assign beta_2_ba2     = $signed(beta_in[2]) + $signed(ba2);
assign beta_6_ba1ba3   = $signed(beta_in[6]) + $signed(ba1ba3);
assign beta_2_ba1ba3   = $signed(beta_in[2]) + $signed(ba1ba3);
assign beta_6_ba2     = $signed(beta_in[6]) + $signed(ba2);
assign beta_3_ba1ba2ba3 = $signed(beta_in[3]) + $signed(ba1ba2ba3);
assign beta_7_ba1ba2ba3 = $signed(beta_in[7]) + $signed(ba1ba2ba3);

// 8 MAX
logic signed [M+1:0] max1;
logic signed [M+1:0] max2;
logic signed [M+1:0] max3;
logic signed [M+1:0] max4;
logic signed [M+1:0] max5;
logic signed [M+1:0] max6;
logic signed [M+1:0] max7;
logic signed [M+1:0] max8;
assign max1 = $signed(0)          > beta_4_ba1ba2ba3       ? $signed(0)          : beta_4_ba1ba2ba3;
assign max2 = ba1ba2ba3              > $signed(beta_in[4]) ? ba1ba2ba3              : $signed(beta_in[4]);
assign max3 = beta_1_ba1ba3         > beta_5_ba2           ? beta_1_ba1ba3         : beta_5_ba2;
assign max4 = beta_1_ba2           > beta_5_ba1ba3         ? beta_1_ba2           : beta_5_ba1ba3;
assign max5 = beta_2_ba2           > beta_6_ba1ba3         ? beta_2_ba2           : beta_6_ba1ba3;
assign max6 = beta_2_ba1ba3         > beta_6_ba2           ? beta_2_ba1ba3         : beta_6_ba2 ;
assign max7 = beta_3_ba1ba2ba3       > $signed(beta_in[7]) ? beta_3_ba1ba2ba3       : $signed(beta_in[7]);
assign max8 = $signed(beta_in[3]) > beta_7_ba1ba2ba3       ? $signed(beta_in[3]) : beta_7_ba1ba2ba3;

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
// cadence infer_multibit "beta_out"
// cadence async_set_reset "nReset"           
always_ff@(posedge Clock, negedge nReset, negedge nClear)
    if(!nReset || !nClear)
    begin
        // beta_out[0] <= 'b0;
        beta_out[1] <= 'b0;
        beta_out[2] <= 'b0;
        beta_out[3] <= 'b0;
        beta_out[4] <= 'b0;
        beta_out[5] <= 'b0;
        beta_out[6] <= 'b0;
        beta_out[7] <= 'b0;
    end
    // else if(!nClear)
         // begin
            // beta_out[1] <= 'b0;
            // beta_out[2] <= 'b0;
            // beta_out[3] <= 'b0;
            // beta_out[4] <= 'b0;
            // beta_out[5] <= 'b0;
            // beta_out[6] <= 'b0;
            // beta_out[7] <= 'b0;
        // end
    else if(Enable)
        begin
            // beta_out[0] <= beta_out_ff[0];
            beta_out[1] <= beta_out_ff[1];
            beta_out[2] <= beta_out_ff[2];
            beta_out[3] <= beta_out_ff[3];
            beta_out[4] <= beta_out_ff[4];
            beta_out[5] <= beta_out_ff[5];
            beta_out[6] <= beta_out_ff[6];
            beta_out[7] <= beta_out_ff[7];
        end
           
endmodule             
