module Epsilon_Pipe #(parameter N = 5, parameter M = 6)
                     (input logic Clock,
                      input logic nReset,
                      input logic signed [7:1][M-1:0] alpha, 
                      input logic signed [7:1][M-1:0] beta,
                      output logic signed [4:1][M:0] epsilon);
             
// Add alphas and betas together
// Result is given in TC
// logic signed [M:0] alpha_beta_01;
logic signed [M:0] alpha_beta_02;
logic signed [M:0] alpha_beta_03;
logic signed [M:0] alpha_beta_04;
logic signed [M:0] alpha_beta_05;
logic signed [M:0] alpha_beta_06;
logic signed [M:0] alpha_beta_07;
logic signed [M:0] alpha_beta_08;
logic signed [M:0] alpha_beta_09;
logic signed [M:0] alpha_beta_10;
logic signed [M:0] alpha_beta_11;
logic signed [M:0] alpha_beta_12;
// logic signed [M:0] alpha_beta_13;
// logic signed [M:0] alpha_beta_14;
logic signed [M:0] alpha_beta_15;
logic signed [M:0] alpha_beta_16;

// Signed additions, no need to worry about sign extension
// assign alpha_beta_01 = $signed(alpha[0]) + $signed(beta[0]);
assign alpha_beta_02 = $signed(alpha[1]) + $signed(beta[4]);
assign alpha_beta_03 = $signed(alpha[6]) + $signed(beta[7]);
assign alpha_beta_04 = $signed(alpha[7]) + $signed(beta[3]);
assign alpha_beta_05 = $signed(alpha[2]) + $signed(beta[5]);
assign alpha_beta_06 = $signed(alpha[3]) + $signed(beta[1]);
assign alpha_beta_07 = $signed(alpha[4]) + $signed(beta[2]);
assign alpha_beta_08 = $signed(alpha[5]) + $signed(beta[6]);
assign alpha_beta_09 = $signed(alpha[2]) + $signed(beta[1]);
assign alpha_beta_10 = $signed(alpha[3]) + $signed(beta[5]);
assign alpha_beta_11 = $signed(alpha[4]) + $signed(beta[6]);
assign alpha_beta_12 = $signed(alpha[5]) + $signed(beta[2]);
// assign alpha_beta_13 = $signed(alpha[0]) + $signed(beta[4]);
// assign alpha_beta_14 = $signed(alpha[1]) + $signed(beta[0]);
assign alpha_beta_15 = $signed(alpha[6]) + $signed(beta[3]);
assign alpha_beta_16 = $signed(alpha[7]) + $signed(beta[7]);
           

// Two layers of MAX operations
// Operands are given in TC
// First layer
logic signed [M:0] max11; 
logic signed [M:0] max12; 
logic signed [M:0] max13; 
logic signed [M:0] max14; 
logic signed [M:0] max15; 
logic signed [M:0] max16; 
logic signed [M:0] max17; 
logic signed [M:0] max18; 
assign max11 = $signed(0)    > alpha_beta_02 ? $signed(0)    : alpha_beta_02;
assign max12 = alpha_beta_03 > alpha_beta_04 ? alpha_beta_03 : alpha_beta_04;
assign max13 = alpha_beta_05 > alpha_beta_06 ? alpha_beta_05 : alpha_beta_06;
assign max14 = alpha_beta_07 > alpha_beta_08 ? alpha_beta_07 : alpha_beta_08;
assign max15 = alpha_beta_09 > alpha_beta_10 ? alpha_beta_09 : alpha_beta_10;
assign max16 = alpha_beta_11 > alpha_beta_12 ? alpha_beta_11 : alpha_beta_12;
assign max17 = $signed(beta[4]) > $signed(alpha[1]) ? $signed(beta[4]) : $signed(alpha[1]);
assign max18 = alpha_beta_15 > alpha_beta_16 ? alpha_beta_15 : alpha_beta_16;
   
// Second layer
logic signed [M:0] max21; 
logic signed [M:0] max22; 
logic signed [M:0] max23; 
logic signed [M:0] max24; 
assign max21 = max11 > max12 ? max11 : max12;
assign max22 = max13 > max14 ? max13 : max14;
assign max23 = max15 > max16 ? max15 : max16;
assign max24 = max17 > max18 ? max17 : max18;
// cadence infer_multibit "epsilon"
// cadence async_set_reset "nReset"
always_ff@(posedge Clock, negedge nReset)
    if(!nReset)
    begin
        epsilon[1] <= 'b0;
        epsilon[2] <= 'b0;
        epsilon[3] <= 'b0;
        epsilon[4] <= 'b0;
    end
    else
    begin
        epsilon[1] <= max21;
        epsilon[2] <= max22;
        epsilon[3] <= max23;
        epsilon[4] <= max24;
    end


endmodule
