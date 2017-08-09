// ================================================================================ 
// Pipelined FPTD
// Gamma and Ext modules operate with Even_Clock
// Alpha, Beta and Epsilon operate with Odd_Clock
// ================================================================================ 

module Section_Pipe_razor2 #(parameter N = 6, parameter M = 6, parameter RazorBit = 1)
                            (input logic Clock_top,
                             input logic Clock_mid,
                             input logic nReset,
                             input logic signed [M-1:0] ba1,
                             input logic signed [N-1:0] ba2,
                             input logic signed [N-1:0] ba3,
                             input logic signed [7:1][M-1:0] alpha_in_DFF, 
                             input logic signed [7:1][M-1:0] beta_in_DFF,
                             output logic Error_current_Section,
                             output logic signed [7:1][M-1:0] alpha_out_DFF,
                             output logic signed [7:1][M-1:0] beta_out_DFF,
                             output logic signed [M-1:0] be1_DFF);
           
logic signed [M:0] ba1ba3;             
logic signed [M:0] ba1ba2ba3;             
logic signed [4:1][M:0] epsilon;
logic Error_current_Alpha;
logic Error_current_Beta;
logic Error_current_Epsilon;
logic Error_current_be1;

Error_Section_Pipe 
Error_Section      (.Error_Alpha(Error_current_Alpha),
                    .Error_Beta(Error_current_Beta),
                    .Error_Epsilon(Error_current_Epsilon),
                    .Error_Ext(Error_current_be1),
                    .Error_Section(Error_current_Section));
                        
// No need to add razor DFFs in Gamma module   
Gamma_Pipe_razor2 #(.N(N),.M(M))
Gamma              (.Clock(Clock_top),
                    .nReset(nReset),
                    .ba1(ba1),
                    .ba2(ba2),
                    .ba3(ba3),
                    .ba1ba3(ba1ba3),
                    .ba1ba2ba3(ba1ba2ba3));

Alpha_Pipe_razor2 #(.N(N),.M(M))
Alpha              (.Clock(Clock_mid),
                    .nReset(nReset),
                    .alpha_in_DFF(alpha_in_DFF), 
                    .ba2(ba2),
                    .ba1ba3(ba1ba3),
                    .ba1ba2ba3(ba1ba2ba3),
                    .Error_current_Alpha(Error_current_Alpha),
                    .alpha_out_DFF(alpha_out_DFF));

Beta_Pipe_razor2 #(.N(N),.M(M),.RazorBit(RazorBit))
Beta              (.Clock(Clock_mid),
                   .nReset(nReset),
                   .beta_in_DFF(beta_in_DFF), 
                   .ba2(ba2),
                   .ba1ba3(ba1ba3),
                   .ba1ba2ba3(ba1ba2ba3),
                   .Error_current_Beta(Error_current_Beta),
                   .beta_out_DFF(beta_out_DFF)); 

Epsilon_Pipe_razor2 #(.N(N),.M(M),.RazorBit(RazorBit))
Epsilon              (.Clock(Clock_mid),
                      .nReset(nReset),
                      .alpha(alpha_in_DFF),
                      .beta(beta_in_DFF),
                      .Error_current_Epsilon(Error_current_Epsilon),
                      .epsilon_DFF(epsilon));
                      
Ext_Pipe_razor2 #(.N(N),.M(M),.RazorBit(RazorBit))
Ext              (.Clock(Clock_top),
                  .nReset(nReset),
                  .ba2(ba2),
                  .epsilon(epsilon),
                  .Error_current_be1(Error_current_be1),
                  .be1_DFF(be1_DFF));       
endmodule
