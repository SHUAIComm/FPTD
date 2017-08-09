module Section_razor1 #(parameter N = 6, parameter M = 6, parameter RazorBit = 1)
                       (input logic Clock,
                        input logic nReset,
                        input logic Enable,
                        input logic signed [M-1:0] ba1_DFF,
                        input logic signed [N-1:0] ba2,
                        input logic signed [N-1:0] ba3,
                        input logic Error_previous_Alpha, 
                        input logic Error_previous_Beta, 
                        input logic Error_previous_be1, 
                        input logic signed [7:1][M-1:0] alpha_in_DFF, 
                        input logic signed [7:1][M-1:0] beta_in_DFF,
                        output logic Error_current_Alpha,
                        output logic Error_current_Beta,
                        output logic Error_current_be1,
                        output logic signed [7:1][M-1:0] alpha_out_DFF,
                        output logic signed [7:1][M-1:0] beta_out_DFF,
                        output logic signed [M-1:0] be1_DFF);
           
logic signed [M:0] ba1ba3;             
logic signed [M:0] ba1ba2ba3;             

            
Gamma #(.N(N),.M(M))
Gamma       (.ba1(ba1_DFF),
             .ba2(ba2),
             .ba3(ba3),
             .ba1ba3(ba1ba3),
             .ba1ba2ba3(ba1ba2ba3));
             
Ext_razor1 #(.N(N),.M(M),.RazorBit(RazorBit))
Ext         (.Clock(Clock),
             .nReset(nReset),
             .Enable(Enable),
             .Error_previous_Alpha(Error_previous_Alpha),
             .Error_previous_Beta(Error_previous_Beta),
             .alpha(alpha_in_DFF), 
             .beta(beta_in_DFF),
             .ba2(ba2),
             .Error_current_be1(Error_current_be1),
             .be1_DFF(be1_DFF));

Alpha_razor1 #(.N(N),.M(M),.RazorBit(RazorBit))
Alpha       (.Clock(Clock),
             .nReset(nReset),
             .Enable(Enable),
             .Error_previous_Alpha(Error_previous_Alpha),
             .Error_previous_be1(Error_previous_be1),
             .alpha_in_DFF(alpha_in_DFF), 
             .ba2(ba2),
             .ba1ba3(ba1ba3),
             .ba1ba2ba3(ba1ba2ba3),
             .Error_current_Alpha(Error_current_Alpha),
             .alpha_out_DFF(alpha_out_DFF));

Beta_razor1 #(.N(N),.M(M),.RazorBit(RazorBit))
Beta        (.Clock(Clock),
             .nReset(nReset),
             .Enable(Enable),
             .Error_previous_Beta(Error_previous_Beta),
             .Error_previous_be1(Error_previous_be1),
             .beta_in_DFF(beta_in_DFF), 
             .ba2(ba2),
             .ba1ba3(ba1ba3),
             .ba1ba2ba3(ba1ba2ba3),
             .Error_current_Beta(Error_current_Beta),
             .beta_out_DFF(beta_out_DFF));             
endmodule