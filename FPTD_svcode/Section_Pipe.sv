// ================================================================================ 
// Pipelined FPTD
// Gamma and Ext modules operate with Even_Clock
// Alpha, Beta and Epsilon operate with Odd_Clock
// ================================================================================ 

module Section_Pipe #(parameter N = 6, parameter M = 6)
                     (input logic Clock,
                      input logic nReset,
                      input logic nClear,
                      input logic Enable,
                      input logic signed [M-1:0] ba1,
                      input logic signed [N-1:0] ba2,
                      input logic signed [N-1:0] ba3,
                      input logic signed [7:1][M-1:0] alpha_in, 
                      input logic signed [7:1][M-1:0] beta_in,
                      output logic signed [7:1][M-1:0] alpha_out,
                      output logic signed [7:1][M-1:0] beta_out,
                      output logic signed [M-1:0] be1);
           
logic signed [M:0] ba1ba3;             
logic signed [M:0] ba1ba2ba3;             
logic signed [4:1][M:0] epsilon;
   
Gamma_Pipe #(.N(N),.M(M))
Gamma       (.Clock(Clock),
             .nReset(nReset),
             .ba1(ba1),
             .ba2(ba2),
             .ba3(ba3),
             .ba1ba3(ba1ba3),
             .ba1ba2ba3(ba1ba2ba3));

Alpha #(.N(N),.M(M))
Alpha  (.Clock(Clock),
        .nReset(nReset),
		.nClear(nClear),
		.Enable(Enable),
        .alpha_in(alpha_in), 
        .ba2(ba2),
        .ba1ba3(ba1ba3),
        .ba1ba2ba3(ba1ba2ba3),
        .alpha_out(alpha_out));

Beta #(.N(N),.M(M))
Beta  (.Clock(Clock),
       .nReset(nReset),
	   .nClear(nClear),
	   .Enable(Enable),
       .beta_in(beta_in), 
       .ba2(ba2),
       .ba1ba3(ba1ba3),
       .ba1ba2ba3(ba1ba2ba3),
       .beta_out(beta_out));  

Epsilon_Pipe #(.N(N),.M(M))
Epsilon       (.Clock(Clock),
               .nReset(nReset),
               .alpha(alpha_in),
               .beta(beta_in),
               .epsilon(epsilon));
                      
Ext_Pipe #(.N(N),.M(M))
Ext       (.Clock(Clock),
           .nReset(nReset),
           .ba2(ba2),
           .epsilon(epsilon),
           .be1(be1));         
endmodule
