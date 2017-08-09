`timescale 1ns / 1ps

module  MUXS #(parameter N = 76)
(
 input  [N-1:0]  INA,
 input  [N-1:0]  INB,
 input  [N-1:0]  INC,
 input  [N-1:0]  IND,
 input   S1,
 input   S2,
 output reg [N-1:0]  OUT
 );

logic [N-1:0] tmp1;
logic [N-1:0] tmp2;

MUX #(.N(N)) mux1 (.INA(INA), .INB(INB), .Sel(S1), .OUT(tmp1));
MUX #(.N(N)) mux2 (.INA(INC), .INB(IND), .Sel(S1), .OUT(tmp2));
MUX #(.N(N)) mux3 (.INA(tmp1), .INB(tmp2), .Sel(S2), .OUT(OUT));

endmodule 




module  MUX #(parameter N = 76)
(
 input  [N-1:0]  INA,
 input  [N-1:0]  INB,
 input   Sel,
 output reg [N-1:0]  OUT
 );

always @(*)
begin : MUX
  if (Sel == 1'b0) begin
    OUT = INA;
  end else begin
    OUT = INB;
  end
end
endmodule 