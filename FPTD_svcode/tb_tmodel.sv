`timescale 1ns/1ps
module tb_Tmodel;
parameter N = 98; 
parameter M = 98;
parameter TCLK = 10;
logic [N-1:0] IN;
logic [N-1:0] OUT;
logic S1;
logic S2;

Tmodel #(.N(N), .M(M))
tmodel (
 .IN(IN),
 .S1(S1),
 .S2(S2),
 .OUT(OUT)
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