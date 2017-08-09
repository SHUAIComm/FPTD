`timescale 1ns/1ps
module tb_comparator;
parameter OutN = 6; 
parameter InN = 40;
parameter TCLK = 10;
logic Clock;
logic nReset;
logic signed [InN-1:0] A;
logic signed [InN-1:0] B;
logic signed [OutN-1:0] C;

comparator #(.InN(InN), .OutN(OutN)) 
comparator  (.nReset(nReset), .Clock(Clock), .A(A), .B(B), .C(C));

always
begin
    Clock = 1'b0;
    #(0.5*TCLK);
    Clock = 1'b1;
    #(0.5*TCLK);
end

initial 
begin
    //nReset = 1'b1;
    //#(0.25*TCLK);
    nReset = 1'b0;
    #(0.25*TCLK);
    nReset = 1'b1;
end

initial
begin
    A = 4532;
    B = 124;
    #(10*TCLK);
    A = 255;
    B = 124;
    #(10*TCLK);
    A = 255;
    B = 2345;
    #(10*TCLK);
    A = ~0;
    B = 0;
    #(10*TCLK);
    $stop;
end
endmodule
