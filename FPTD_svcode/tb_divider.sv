`timescale 1ns/1ps
module tb_divider;
parameter TCLK = 10;

reg Clock;
reg nReset;
logic ClockOut;
reg Sel;

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
    Sel = 1'b0;
    #(100*TCLK);
    Sel = 1'b1;
    #(100*TCLK);
    Sel = 1'b0;
    #(100*TCLK);
    Sel = 1'b1;
    #(100*TCLK);
    $stop;
end

divider U1 (.nReset(nReset), .Clock(Clock), .Sel(Sel), .ClockOut(ClockOut));

endmodule