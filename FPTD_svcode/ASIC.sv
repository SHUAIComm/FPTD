`timescale 1ns / 1ps

module ASIC (
  input      nReset,
  input      Clock,
  input      Mode,
  input      Go,
  input      Enable_f,
  input      Sel_f,
  input      S1,
  input      S2,
  input      S3,
  input      [6:0] In,
  output reg [6:0] DOut1,
  output reg [6:0] DOut2,
  output     [6:0] TOut,
  output     bitout1,
  output     bitout2,
  output     KeepShift,
  output     Start,
  output     Start2,
  output     TestReady,
  output reg Dclk
);

parameter N1 = 200;
parameter N2 = 7;
//parameter N3 = 98;
//parameter N4 = 90;
parameter N3 = 89;
parameter N4 = 79;
parameter FL = 104;
parameter N = 4;
parameter M = 5;
parameter DCmax = 200;

logic Inkeep;
logic Inshift;
logic Outkeep;
logic Outshift;
//logic TestReady;
logic SelCLK;
logic Sclk;
logic [N2-1:0][N1-1:0] InData;
logic [N3-1:0] Tdata_in;
logic [N4-1:0] Tdata_out;
logic [6:0] DOut1_tmp;
logic [6:0] DOut2_tmp;


logic [FL-1:0] b1_ideal;
logic signed [2:0][N-1:0] but1; 
logic signed [FL+2:0][N-1:0] bua2; 
logic signed [FL-1:0][N-1:0] bua3; 
logic signed [2:0][N-1:0] blt1; 
logic signed [FL+2:0][N-1:0] bla2; 
logic Ready1;
logic Valid_Data1;
logic Ready2;
logic Valid_Data2;
logic [FL-1:0] b1_error1;
logic [FL-1:0] b1_error2;

reg [N2-1:0][N1-1:0] BusData;
reg [N2-1:0][N1-1:0] KeepData;

always @ (posedge Clock, negedge nReset) begin
  if (!nReset) begin
    BusData <= 0;
    KeepData <= 0;
  end
  else begin
    BusData <= KeepData;
    if (!Inkeep)
        KeepData <= KeepData;
    else
		KeepData <= InData;
  end
end

assign Tdata_in = InData[0][N3-1:0];

genvar i, j;

for (i=0;i<3;i++)
begin
	for (j=0;j<4;j++)
	begin
	assign but1[i][j] = BusData[0][N*(i)+j];
	end
end

for (i=0;i<47;i++)
begin
	for (j=0;j<4;j++)
	begin
	assign bua2[i][j] = BusData[0][N*(i+3)+j];
	end
end

for (i=0;i<50;i++)
begin
	for (j=0;j<4;j++)
	begin
	assign bua2[i+47][j] = BusData[1][N*(i)+j];
	end
end

for (i=0;i<FL+3-97;i++)
begin
	for (j=0;j<4;j++)
	begin
	assign bua2[i+97][j] = BusData[2][N*(i)+j];
	end
end

for (i=0;i<50-(FL+3-97);i++)
begin
	for (j=0;j<4;j++)
	begin
	assign bua3[i][j] = BusData[2][N*(i+FL+3-97)+j];
	end
end

for (i=0;i<50;i++)
begin
	for (j=0;j<4;j++)
	begin
	assign bua3[i+50-(FL+3-97)][j] = BusData[3][N*(i)+j];
	end
end

//FL-(50+50-(FL+3-97))=FL+FL-194
for (i=0;i<FL+FL-194;i++)
begin
	for (j=0;j<4;j++)
	begin
	assign bua3[i+194-FL][j] = BusData[4][N*(i)+j];
	end
end

for (i=0;i<3;i++)
begin
	for (j=0;j<4;j++)
	begin
	assign blt1[i][j] = BusData[4][N*(i+FL+FL-194)+j];
	end
end

for (i=0;i<50-(FL+FL-194+3);i++)
begin
	for (j=0;j<4;j++)
	begin
	assign bla2[i][j] = BusData[4][N*(i+FL+FL-194+3)+j];
	end
end

for (i=0;i<50;i++)
begin
	for (j=0;j<4;j++)
	begin
	assign bla2[i+50-(FL+FL-194+3)][j] = BusData[5][N*(i)+j];
	end
end

//50-(FL+FL-194+3)+50=291-FL-FL
//FL+3-(291-FL-FL)=3*FL-288
for (i=0;i<3*FL-288;i++)
begin
	for (j=0;j<4;j++)
	begin
	assign bla2[i+291-FL-FL][j] = BusData[6][N*(i)+j];
	end
end

for (j=0;j<FL;j++)
begin
assign b1_ideal[j] = BusData[6][N*(3*FL-288)+j];
end


SysControl #(.N1(N1), .N2(N2))
SysControl1 (
  .nReset(nReset),
  .Clock(Clock),
  .Mode(Mode),
  .Go(Go),
  .Enable_f(Enable_f),
  .Sel_f(Sel_f),
  .Start(Start),
  .Start2(Start2),
  .TestReady(TestReady),
  .Inkeep(Inkeep),
  .Inshift(Inshift),
  .Outkeep(Outkeep),
  .Outshift(Outshift),
  .SelCLK(SelCLK)
);

divider divider1 (.nReset(nReset), .Clock(Clock), .Sel(Sel_f), .ClockOut(Dclk));

assign Sclk = (Mode ? Enable_f : SelCLK) ? Dclk : Clock;

InShiftReg #(.N1(N1), .N2(N2))
InShiftReg1 (.nReset(nReset), .Clock(Sclk), .SelShift(Inshift), .SelKeep(Inkeep), .In(In), .Out(InData));

OutShiftReg #(.N1(N4), .N2(7))
OutShiftReg1 (.nReset(nReset), .Clock(Sclk), .SelShift(Outshift), .SelKeep(Outkeep), .In(Tdata_out), .Out(TOut));

Tmodel #(.N(N), .M(M), .N1(N3), .N2(N4))
tmodel (
 .IN(Tdata_in),
 .S1(S1),
 .S2(S2),
 .S3(S3),
 .Clock(Clock),
 .nReset(nReset),
 .OUT(Tdata_out)
 );

FPTD #(.FL(FL), .DCmax(DCmax), .N(N), .M(M)) 
FPTD1            (.Clock(Clock), 
                  .nReset(nReset), 
                  .Start(Start), 
                  .b1_ideal(b1_ideal),
                  .but1(but1), 
                  .bua2(bua2), 
                  .bua3(bua3), 
                  .blt1(blt1), 
                  .bla2(bla2), 
                  .Ready(Ready1),
                  .Valid_Data(Valid_Data1),
                  .Errors(DOut1_tmp),
				  .b1_error(b1_error1));
				  
FPTD_Pipe_razor1 #(.FL(FL), .DCmax(DCmax), .N(N), .M(M)) 
FPTD2            (.Clock(Clock), 
                  .nReset(nReset), 
                  .Start(Start), 
                  .b1_ideal(b1_ideal),
                  .but1(but1), 
                  .bua2(bua2), 
                  .bua3(bua3), 
                  .blt1(blt1), 
                  .bla2(bla2), 
                  .Ready(Ready2),
                  .Valid_Data(Valid_Data2),
                  .Errors(DOut2_tmp),
				  .b1_error(b1_error2));

ErrorReg #(.FL(FL))
ErrorReg1 (.nReset(nReset),
			.Clock(Sclk),
			.b1_error1(b1_error1),
			.b1_error2(b1_error2),
			.Ready(Ready1),
			.Valid_Data(Valid_Data1),
			.KeepShift(KeepShift),
			.bitout1(bitout1),
			.bitout2(bitout2));
				  
always @ (posedge Sclk, negedge nReset)
begin
  if(!nReset)
  begin
    DOut1 <= 0;
	DOut2 <= 0;
  end
  else
  begin
    DOut1 <= DOut1_tmp;
	DOut2 <= DOut2_tmp;
  end
end

endmodule
