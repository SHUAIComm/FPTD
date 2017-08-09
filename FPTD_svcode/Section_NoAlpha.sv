module Section_NoAlpha #(parameter N = 6, parameter M = 6)
                        (input logic Clock,
                         input logic nReset,
                         input logic nClear,
                         input logic Enable,
                         input logic b1_ideal,
                         input logic signed [M-1:0] ba1,
                         input logic signed [N-1:0] ba2,
                         input logic signed [N-1:0] ba3,
                         input logic signed [7:1][M-1:0] alpha_in, 
                         input logic signed [7:1][M-1:0] beta_in,
                         output logic signed [7:1][M-1:0] beta_out,
                         output logic signed [M-1:0] be1,
                         output logic b1_error);
           
logic signed [M:0] ba1ba3;             
logic signed [M:0] ba1ba2ba3;             
             
Gamma #(.N(N),.M(M))
Gamma  (.ba1(ba1),
        .ba2(ba2),
        .ba3(ba3),
        .ba1ba3(ba1ba3),
        .ba1ba2ba3(ba1ba2ba3));
             
Ext #(.N(N),.M(M))
Ext  (.Clock(Clock),
      .nReset(nReset),
      .nClear(nClear),
      .Enable(Enable),
      .alpha(alpha_in), 
      .beta(beta_in),
      .ba2(ba2),
      .be1(be1));

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
       
EstimatedBit #(.N(N), .M(M))
EstimatedBit  (.Clock(Clock),
               .nReset(nReset),
               .nClear(nClear),
               .Enable(Enable),
               .ba1(ba1),
               .ba3(ba3),
               .be1(be1),
               .b1_ideal(b1_ideal),
               .b1_error(b1_error));       
endmodule
