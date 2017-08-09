`timescale 1ns/1ps
module tb_OutShiftReg;
parameter TCLK = 10;
parameter N1 = 90; 
parameter N2 = 6;
logic      nReset;
logic      Clock;
logic      SelShift;
logic      SelKeep;
logic      [N1-1:0] In;
logic      [N2-1:0] Out;

reg [N2-1:0][N1-1:0] Reg;
reg [N2-1:0][N1-1:0] OutReg;

integer i, j;

always
begin
    Clock = 1'b0;
    #(0.5*TCLK);
    Clock = 1'b1;
    #(0.5*TCLK);
end

initial 
begin
    Reg[0] = 6432;
    Reg[1] = ~0;
    Reg[2] = 281267;
    Reg[3] = 231;
    Reg[4] = ~0;
    Reg[5] = 29389123;
    OutReg = 0;
    //nReset = 1'b1;
    //#(0.25*TCLK);
    nReset = 1'b0;
    #(0.25*TCLK);
    nReset = 1'b1;
end

assign In = Reg[5];

always @ (posedge Clock) begin
for (i=1;i<N2;i=i+1)
begin
    Reg[i] <= Reg[i-1];
end

for (i=0;i<N2;i=i+1)
begin
    OutReg[i][0] <= Out[i];
end

begin
for (j=0; j<N2; j=j+1)
  begin
	for (i=1; i<N1; i=i+1)
	  begin
		OutReg[j][i] <= OutReg[j][i-1];
	  end
  end
end
end

initial
begin
    SelShift = 1'b0;
    SelKeep = 1'b0;
    #(6*TCLK);
    SelShift = 1'b0;
    SelKeep = 1'b1;
    #(20*TCLK);
    SelShift = 1'b1;
    SelKeep = 1'b1;
    #(20*TCLK);
    SelShift = 1'b1;
    SelKeep = 1'b0;
    #(92*TCLK);
    $stop;
end

OutShiftReg #(.N1(N1), .N2(N2))
 U1 (.nReset(nReset), .Clock(Clock), .SelShift(SelShift), .SelKeep(SelKeep), .In(In), .Out(Out));

endmodule