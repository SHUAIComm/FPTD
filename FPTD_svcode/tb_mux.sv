`timescale 1ns/1ps
module tb_mux;
parameter N = 90; 
parameter TCLK = 10;
logic [N-1:0] A1;
logic [N-1:0] A2;
logic [N-1:0] A3;
logic [N-1:0] A4;
logic [N-1:0] OUT;
logic S1;
logic S2;

MUXS #(.N(N))
muxs (
 .INA(A1),
 .INB(A2),
 .INC(A3),
 .IND(A4),
 .S1(S1),
 .S2(S2),
 .OUT(OUT)
 );

initial
begin
    A1 = 4532;
    A2 = 124;
    A3 = 255;
    A4 = 2345;
    S1 = 0;
    S2 = 0;
    #(10*TCLK);
    S1 = 1;
    S2 = 0;
    #(10*TCLK);
    S1 = 0;
    S2 = 1;
    #(10*TCLK);
    S1 = 1;
    S2 = 1;
    #(10*TCLK);
    $stop;
end
endmodule