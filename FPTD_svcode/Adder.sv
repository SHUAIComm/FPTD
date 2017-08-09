module Adder #(parameter N=4) 
              (input logic signed [N-1:0] A,
               input logic signed [N-1:0] B,
               output logic signed [N:0] C);
                        
assign C = A + B;

endmodule
