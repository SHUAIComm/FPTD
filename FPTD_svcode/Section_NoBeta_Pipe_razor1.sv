// ================================================================================ 
// Pipelined FPTD
// Gamma and Ext modules operate with Even_Clock
// Alpha, Beta and Epsilon operate with Odd_Clock
// ================================================================================ 

module Section_NoBeta_Pipe_razor1 #(parameter N = 6, parameter M = 6, parameter RazorBit = 1)
                            (input logic Clock,
                             input logic nReset,
                             input logic nClear,
                             input logic Enable,
                             input logic b1_ideal,
                             input logic signed [M-1:0] ba1,
                             input logic signed [N-1:0] ba2,
                             input logic signed [N-1:0] ba3,
                             input logic Error_previous_Alpha, 
                             input logic Error_previous_Beta,  
                             input logic Error_previous_be1,  
                             input logic signed [7:1][M-1:0] alpha_in_DFF, 
                             input logic signed [7:1][M-1:0] beta_in_DFF,
                             output logic Error_current_Alpha,
                             output logic Error_current_be1,
                             output logic signed [7:1][M-1:0] alpha_out_DFF,
                             output logic signed [M-1:0] be1_DFF,
                             output logic b1_error);
           
logic signed [M:0] ba1ba3;             
logic signed [M:0] ba1ba2ba3;             
logic signed [4:1][M:0] epsilon;
logic Error_current_Epsilon;
// No need to add razor DFFs in Gamma module   
Gamma_Pipe_razor1 #(.N(N),.M(M))
Gamma              (.Clock(Clock),
                    .nReset(nReset),
                    .nClear(nClear),
                    .Enable(Enable),
                    .Error_previous_be1(Error_previous_be1),
                    .ba1(ba1),
                    .ba2(ba2),
                    .ba3(ba3),
                    .ba1ba3(ba1ba3),
                    .ba1ba2ba3(ba1ba2ba3));

Alpha_Pipe_razor1 #(.N(N),.M(M))
Alpha              (.Clock(Clock),
                    .nReset(nReset),
                    .nClear(nClear),
                    .Enable(~Enable),
                    .Error_previous_Alpha(Error_previous_Alpha),
                    .alpha_in_DFF(alpha_in_DFF), 
                    .ba2(ba2),
                    .ba1ba3(ba1ba3),
                    .ba1ba2ba3(ba1ba2ba3),
                    .Error_current_Alpha(Error_current_Alpha),
                    .alpha_out_DFF(alpha_out_DFF));


Epsilon_Pipe_razor1 #(.N(N),.M(M),.RazorBit(RazorBit))
Epsilon              (.Clock(Clock),
                      .nReset(nReset),
                      .nClear(nClear),
                      .Enable(~Enable),
                      .Error_previous_Alpha(Error_previous_Alpha),
                      .Error_previous_Beta(Error_previous_Beta),
                      .alpha(alpha_in_DFF),
                      .beta(beta_in_DFF),
                      .Error_current_Epsilon(Error_current_Epsilon),
                      .epsilon_DFF(epsilon));
                      
Ext_Pipe_razor1 #(.N(N),.M(M),.RazorBit(RazorBit))
Ext              (.Clock(Clock),
                  .nReset(nReset),
                  .Enable(Enable),
                  .nClear(nClear),
                  .Error_previous_Epsilon(Error_current_Epsilon),
                  .ba2(ba2),
                  .epsilon(epsilon),
                  .Error_current_be1(Error_current_be1),
                  .be1_DFF(be1_DFF));   
                 
EstimatedBit #(.N(N), .M(M))
EstimatedBit  (.Clock(Clock),
               .nReset(nReset),
               .nClear(nClear),
               .Enable(~Enable),
               .ba1(ba1),
               .ba3(ba3),
               .be1(be1_DFF),
               .b1_ideal(b1_ideal),
               .b1_error(b1_error));     
endmodule
