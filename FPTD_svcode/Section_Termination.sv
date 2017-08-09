module Section_Termination #(parameter N = 6, parameter M = 6)
                            (input logic Clock,
                             input logic nReset,
                             input logic nClear,
                             input logic Enable,
                             input logic signed [N-1:0] ba1,
                             input logic signed [N-1:0] ba2,
                             input logic signed [7:1][M-1:0] beta_in,
                             output logic signed [7:1][M-1:0] beta_out);
           
logic signed [M:0] ba1ba3;             
logic signed [M:0] ba1ba2ba3;             
             
Gamma #(.N(N),.M(M))
Gamma  (.ba1({ba1[N-1],ba1}),
        .ba2(ba2),
        .ba3({N{1'b0}}),
        .ba1ba3(ba1ba3),
        .ba1ba2ba3(ba1ba2ba3));

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
endmodule
