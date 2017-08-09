`timescale 1ns / 1ps

module  DMUXS #(parameter N = 84)
(
 input  [N-1:0]  IN,
 input  S1,
 input  S2,
 output reg [N-1:0]  OUTA,
 output reg [N-1:0]  OUTB,
 output reg [N-1:0]  OUTC,
 output reg [N-1:0]  OUTD
 );

logic [N-1:0] tmp1;
logic [N-1:0] tmp2;

DMUX #(.N(N)) dmux1 (.IN(IN), .Sel(S2), .OUTA(tmp1), .OUTB(tmp2));
DMUX #(.N(N)) dmux2 (.IN(tmp1), .Sel(S1), .OUTA(OUTA), .OUTB(OUTB));
DMUX #(.N(N)) dmux3 (.IN(tmp2), .Sel(S1), .OUTA(OUTC), .OUTB(OUTD));

endmodule 


module  DMUX #(parameter N = 84)
(
 input  [N-1:0]  IN,
 input  Sel,
 output reg [N-1:0]  OUTA,
 output reg [N-1:0]  OUTB
 );

always @(*)
begin : MUX
  if (Sel == 1'b0) begin
    OUTA = IN;
	  OUTB = 'b0;
  end else begin
    OUTA = 'b0;
    OUTB = IN;
  end
end
endmodule 