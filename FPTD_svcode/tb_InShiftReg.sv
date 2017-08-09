`timescale 1ns/1ps
module tb_InShiftReg;
parameter TCLK = 10;
parameter N1 = 102; 
parameter N2 = 6;
logic      nReset;
logic      Clock;
logic      SelShift;
logic      SelKeep;
logic      [N2-1:0] In;
logic     [N2-1:0][N1-1:0] Out1;

reg [N1-1:0] Reg1;
reg [N1-1:0] Reg2;
reg [N1-1:0] Reg3;
reg [N1-1:0] Reg4;
reg [N1-1:0] Reg5;
reg [N1-1:0] Reg6;

integer i;

always
begin
    Clock = 1'b0;
    #(0.5*TCLK);
    Clock = 1'b1;
    #(0.5*TCLK);
end

initial 
begin
    Reg1 = 6432;
    Reg2 = ~0;
    Reg3 = 281267;
    Reg4 = 231;
    Reg5 = ~0;
    Reg6 = 29389123;
    //nReset = 1'b1;
    //#(0.25*TCLK);
    nReset = 1'b0;
    #(0.25*TCLK);
    nReset = 1'b1;
end

assign        In[0]=Reg1[N1-1];
assign        In[1]=Reg2[N1-1];
assign        In[2]=Reg3[N1-1];
assign        In[3]=Reg4[N1-1];
assign        In[4]=Reg5[N1-1];
assign        In[5]=Reg6[N1-1];

always @ (posedge Clock) begin
for (i=N1-1;i>1;i=i-1)
begin
    Reg1[i]<=Reg1[i-1];
    Reg2[i]<=Reg2[i-1];
    Reg3[i]<=Reg3[i-1];
    Reg4[i]<=Reg4[i-1];
    Reg5[i]<=Reg5[i-1];
    Reg6[i]<=Reg6[i-1];
end
end

initial
begin
    SelShift = 1'b0;
    SelKeep = 1'b0;
    #(102*TCLK);
    SelShift = 1'b0;
    SelKeep = 1'b1;
    #(20*TCLK);
    SelShift = 1'b1;
    SelKeep = 1'b1;
    #(20*TCLK);
    SelShift = 1'b1;
    SelKeep = 1'b0;
    #(6*TCLK);
    $stop;
end

InShiftReg #(.N1(N1), .N2(N2))
 U1 (.nReset(nReset), .Clock(Clock), .SelShift(SelShift), .SelKeep(SelKeep), .In(In), .Out(Out1));

endmodule