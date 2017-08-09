`timescale 1ns/1ps
module tb_dmux;
parameter N = 98; 
parameter TCLK = 10;
logic [N-1:0] A1;
logic [N-1:0] A2;
logic [N-1:0] A3;
logic [N-1:0] A4;
logic [N-1:0] IN;
logic S1;
logic S2;

DMUXS #(.N(N))
dmuxs (
 .IN(IN),
 .S1(S1),
 .S2(S2),
 .OUTA(A1),
 .OUTB(A2),
 .OUTC(A3),
 .OUTD(A4)
 );

initial
begin
    IN = 4532;
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