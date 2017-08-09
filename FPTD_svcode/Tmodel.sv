`timescale 1ns / 1ps

module  Tmodel #(parameter N = 4, parameter M = 5, parameter N1 = 89, parameter N2 = 79)
(
 input  [N1-1:0]  IN,
 input  S1,
 input  S2,
 input  S3,
 input  Clock,
 input  nReset,
 output [N2-1:0]  OUT
 );

logic [N1-1:0] A1tmp;
logic [N1-1:0] A2tmp;
logic [N1-1:0] A3tmp;
logic [N1-1:0] A4tmp;
reg [N1-1:0] A1;
reg [N1-1:0] A2;
reg [N1-1:0] A3;
reg [N1-1:0] A4;
logic [N1-1:0] Lin;
logic [N1-1:0] IN_tmp;
logic [N2-1:0] B1;
logic [N2-1:0] B2;
logic [N2-1:0] B3;
logic [N2-1:0] B4;
reg [N2-1:0] Lout;
logic [N2-1:0] OUT_tmp;

genvar i, j;

DMUX #(.N(N1)) dmux (.IN(IN), .Sel(S3), .OUTA(Lin), .OUTB(IN_tmp));
MUX #(.N(N2)) mux (.INA(Lout), .INB(OUT_tmp), .Sel(S3), .OUT(OUT));
always @ (posedge Clock)
begin
	Lout <= Lin[N2-1:0];
end
//assign Lout = Lin[N2-1:0];

DMUXS #(.N(N1))
dmuxs (
 .IN(IN_tmp),
 .S1(S1),
 .S2(S2),
 .OUTA(A1tmp),
 .OUTB(A2tmp),
 .OUTC(A3tmp),
 .OUTD(A4tmp)
);

always @ (posedge Clock, negedge nReset) begin
  if (!nReset) begin
    A1 <= 0;
    A2 <= 0;
    A3 <= 0;
    A4 <= 0;
  end
  else begin
    A1 <= A1tmp;
    A2 <= A2tmp;
    A3 <= A3tmp;
    A4 <= A4tmp;
  end
end

//test section 1
logic S1_nClear;
logic S1_Enable;
logic S1_b1_ideal;
logic signed [M-1:0] S1_ba1;
logic signed [N-1:0] S1_ba2;
logic signed [N-1:0] S1_ba3;
logic signed [7:1][M-1:0] S1_alpha_in; 
logic signed [7:1][M-1:0] S1_beta_in;
logic signed [7:1][M-1:0] S1_alpha_out;
logic signed [7:1][M-1:0] S1_beta_out;
logic signed [M-1:0] S1_be1;
logic S1_b1_error;

for (i=0;i<M;i++)
begin
	assign S1_ba1[i] = A1[i];
end

for (i=0;i<N;i++)
begin
	assign S1_ba2[i] = A1[i+M];
end

for (i=0;i<N;i++)
begin
	assign S1_ba3[i] = A1[i+M+N];
end

for (i=0;i<7;i++)
begin
	for (j=0;j<M;j++)
	begin
	assign S1_alpha_in[i+1][j] = A1[i*M+j+M+N+N];
	end
end

for (i=0;i<7;i++)
begin
	for (j=0;j<M;j++)
	begin
	assign S1_beta_in[i+1][j] = A1[i*M+j+M+N+N+7*M];
	end
end

assign S1_b1_ideal = A1[M+N+N+7*M+7*M];
assign S1_nClear = A1[M+N+N+7*M+7*M+1];
assign S1_Enable = A1[M+N+N+7*M+7*M+2];
 
Section #(.N(N),.M(M))
Section1  (.Clock(Clock),
		  .nReset(nReset),
		  .nClear(S1_nClear),
		  .Enable(S1_Enable),
		  .b1_ideal(S1_b1_ideal),
		  .ba1(S1_ba1),
		  .ba2(S1_ba2),
		  .ba3(S1_ba3),
		  .alpha_in(S1_alpha_in), 
		  .beta_in(S1_beta_in),
		  .alpha_out(S1_alpha_out),
		  .beta_out(S1_beta_out),
		  .be1(S1_be1),
		  .b1_error(S1_b1_error));
 
for (i=0;i<7;i++)
begin
	for (j=0;j<M;j++)
	begin
	assign B1[i*M+j] = S1_alpha_out[i+1][j];
	end
end

for (i=0;i<7;i++)
begin
	for (j=0;j<M;j++)
	begin
	assign B1[i*M+j+7*M] = S1_beta_out[i+1][j];
	end
end

for (i=0;i<M;i++)
begin
	assign B1[i+7*M+7*M] = S1_be1[i];
end

assign B1[7*M+7*M+M] = S1_b1_error;
assign B1[7*M+7*M+M+1] = 0;
assign B1[7*M+7*M+M+2] = 0;
assign B1[7*M+7*M+M+3] = 0;
//end section 1

//test section_pipe_razor1 2
logic S2_Error_previous_Alpha;
logic S2_Error_previous_Beta;
logic S2_Error_previous_be1; 
logic S2_nClear;
logic S2_Enable;
logic S2_b1_ideal;
logic signed [M-1:0] S2_ba1;
logic signed [N-1:0] S2_ba2;
logic signed [N-1:0] S2_ba3;
logic signed [7:1][M-1:0] S2_alpha_in; 
logic signed [7:1][M-1:0] S2_beta_in;
logic signed [7:1][M-1:0] S2_alpha_out;
logic signed [7:1][M-1:0] S2_beta_out;
logic signed [M-1:0] S2_be1;
logic S2_b1_error;
logic S2_Error_current_Alpha;
logic S2_Error_current_Beta;
logic S2_Error_current_be1;

for (i=0;i<M;i++)
begin
	assign S2_ba1[i] = A2[i];
end

for (i=0;i<N;i++)
begin
	assign S2_ba2[i] = A2[i+M];
end

for (i=0;i<N;i++)
begin
	assign S2_ba3[i] = A2[i+M+N];
end

for (i=0;i<7;i++)
begin
	for (j=0;j<M;j++)
	begin
	assign S2_alpha_in[i+1][j] = A2[i*M+j+M+N+N];
	end
end

for (i=0;i<7;i++)
begin
	for (j=0;j<M;j++)
	begin
	assign S2_beta_in[i+1][j] = A2[i*M+j+M+N+N+7*M];
	end
end

assign S2_b1_ideal = A2[M+N+N+7*M+7*M];
assign S2_nClear = A2[M+N+N+7*M+7*M+1];
assign S2_Enable = A2[M+N+N+7*M+7*M+2]; 
assign S2_Error_previous_Alpha = A2[M+N+N+7*M+7*M+3];
assign S2_Error_previous_Beta = A2[M+N+N+7*M+7*M+4];
assign S2_Error_previous_be1 = A2[M+N+N+7*M+7*M+5]; 

Section_Pipe_razor1 #(.N(N),.M(M))
Section2  (.Clock(Clock),
		  .nReset(nReset),
		  .nClear(S2_nClear),
		  .Enable(S2_Enable),
		  .b1_ideal(S2_b1_ideal),
		  .ba1(S2_ba1),
		  .ba2(S2_ba2),
		  .ba3(S2_ba3),
		  .Error_previous_Alpha(S2_Error_previous_Alpha),
		  .Error_previous_Beta(S2_Error_previous_Beta), 
		  .Error_previous_be1(S2_Error_previous_be1),  
		  .alpha_in_DFF(S2_alpha_in), 
		  .beta_in_DFF(S2_beta_in),
		  .Error_current_Alpha(S2_Error_current_Alpha),
		  .Error_current_Beta(S2_Error_current_Beta),
		  .Error_current_be1(S2_Error_current_be1),
		  .alpha_out_DFF(S2_alpha_out),
		  .beta_out_DFF(S2_beta_out),
		  .be1_DFF(S2_be1),
		  .b1_error(S2_b1_error));
 
for (i=0;i<7;i++)
begin
	for (j=0;j<M;j++)
	begin
	assign B2[i*M+j] = S2_alpha_out[i+1][j];
	end
end

for (i=0;i<7;i++)
begin
	for (j=0;j<M;j++)
	begin
	assign B2[i*M+j+7*M] = S2_beta_out[i+1][j];
	end
end

for (i=0;i<M;i++)
begin
	assign B2[i+7*M+7*M] = S2_be1[i];
end

assign B2[7*M+7*M+M] = S2_b1_error;
assign B2[7*M+7*M+M+1] = S2_Error_current_Alpha;
assign B2[7*M+7*M+M+2] = S2_Error_current_Beta;
assign B2[7*M+7*M+M+3] = S2_Error_current_be1;
//end section_pipe_razor1 2

//test section_pipe 3
//logic S3_b1_ideal;
logic S3_nClear;
logic S3_Enable;
logic signed [M-1:0] S3_ba1;
logic signed [N-1:0] S3_ba2;
logic signed [N-1:0] S3_ba3;
logic signed [7:1][M-1:0] S3_alpha_in; 
logic signed [7:1][M-1:0] S3_beta_in;
logic signed [7:1][M-1:0] S3_alpha_out;
logic signed [7:1][M-1:0] S3_beta_out;
logic signed [M-1:0] S3_be1;
//logic S3_b1_error;

for (i=0;i<M;i++)
begin
	assign S3_ba1[i] = A3[i];
end

for (i=0;i<N;i++)
begin
	assign S3_ba2[i] = A3[i+M];
end

for (i=0;i<N;i++)
begin
	assign S3_ba3[i] = A3[i+M+N];
end

for (i=0;i<7;i++)
begin
	for (j=0;j<M;j++)
	begin
	assign S3_alpha_in[i+1][j] = A3[i*M+j+M+N+N];
	end
end

for (i=0;i<7;i++)
begin
	for (j=0;j<M;j++)
	begin
	assign S3_beta_in[i+1][j] = A3[i*M+j+M+N+N+7*M];
	end
end

assign S3_nClear = A3[M+N+N+7*M+7*M];
assign S3_Enable = A3[M+N+N+7*M+7*M+1];
//assign S3_b1_ideal = A3[M+N+N+7*M+7*M];
 
Section_Pipe #(.N(N),.M(M))
Section3  (.Clock(Clock),
		  .nReset(nReset),
		  .nClear(S3_nClear),
		  .Enable(S3_Enable),
		  .ba1(S3_ba1),
		  .ba2(S3_ba2),
		  .ba3(S3_ba3),
		  .alpha_in(S3_alpha_in), 
		  .beta_in(S3_beta_in),
		  .alpha_out(S3_alpha_out),
		  .beta_out(S3_beta_out),
		  .be1(S3_be1));
 
for (i=0;i<7;i++)
begin
	for (j=0;j<M;j++)
	begin
	assign B3[i*M+j] = S3_alpha_out[i+1][j];
	end
end

for (i=0;i<7;i++)
begin
	for (j=0;j<M;j++)
	begin
	assign B3[i*M+j+7*M] = S3_beta_out[i+1][j];
	end
end

for (i=0;i<M;i++)
begin
	assign B3[i+7*M+7*M] = S3_be1[i];
end

assign B3[7*M+7*M+M] = 0;
assign B3[7*M+7*M+M+1] = 0;
assign B3[7*M+7*M+M+2] = 0;
assign B3[7*M+7*M+M+3] = 0;
//assign B3[7*M+7*M+M] = S3_b1_error;
//end section_pipe 3

//test section_razor1 4
logic S4_Error_previous_Alpha;
logic S4_Error_previous_Beta;
logic S4_Error_previous_be1; 
logic S4_Enable;
logic signed [M-1:0] S4_ba1;
logic signed [N-1:0] S4_ba2;
logic signed [N-1:0] S4_ba3;
logic signed [7:1][M-1:0] S4_alpha_in; 
logic signed [7:1][M-1:0] S4_beta_in;
logic signed [7:1][M-1:0] S4_alpha_out;
logic signed [7:1][M-1:0] S4_beta_out;
logic signed [M-1:0] S4_be1;
logic S4_Error_current_Alpha;
logic S4_Error_current_Beta;
logic S4_Error_current_be1;

for (i=0;i<M;i++)
begin
	assign S4_ba1[i] = A4[i];
end

for (i=0;i<N;i++)
begin
	assign S4_ba2[i] = A4[i+M];
end

for (i=0;i<N;i++)
begin
	assign S4_ba3[i] = A4[i+M+N];
end

for (i=0;i<7;i++)
begin
	for (j=0;j<M;j++)
	begin
	assign S4_alpha_in[i+1][j] = A4[i*M+j+M+N+N];
	end
end

for (i=0;i<7;i++)
begin
	for (j=0;j<M;j++)
	begin
	assign S4_beta_in[i+1][j] = A4[i*M+j+M+N+N+7*M];
	end
end

assign S4_Enable = A4[M+N+N+7*M+7*M];
assign S4_Error_previous_Alpha = A4[M+N+N+7*M+7*M+1];
assign S4_Error_previous_Beta = A4[M+N+N+7*M+7*M+2];
assign S4_Error_previous_be1 = A4[M+N+N+7*M+7*M+3]; 
 
Section_razor1 #(.N(N),.M(M))
Section4  (.Clock(Clock),
		  .nReset(nReset),
		  .Enable(S4_Enable),
		  .ba1_DFF(S4_ba1),
		  .ba2(S4_ba2),
		  .ba3(S4_ba3),
		  .Error_previous_Alpha(S4_Error_previous_Alpha),
		  .Error_previous_Beta(S4_Error_previous_Beta), 
		  .Error_previous_be1(S4_Error_previous_be1), 
		  .alpha_in_DFF(S4_alpha_in), 
		  .beta_in_DFF(S4_beta_in),
		  .Error_current_Alpha(S4_Error_current_Alpha),
		  .Error_current_Beta(S4_Error_current_Beta),
		  .Error_current_be1(S4_Error_current_be1),
		  .alpha_out_DFF(S4_alpha_out),
		  .beta_out_DFF(S4_beta_out),
		  .be1_DFF(S4_be1));
 
for (i=0;i<7;i++)
begin
	for (j=0;j<M;j++)
	begin
	assign B4[i*M+j] = S4_alpha_out[i+1][j];
	end
end

for (i=0;i<7;i++)
begin
	for (j=0;j<M;j++)
	begin
	assign B4[i*M+j+7*M] = S4_beta_out[i+1][j];
	end
end

for (i=0;i<M;i++)
begin
	assign B4[i+7*M+7*M] = S4_be1[i];
end

assign B4[7*M+7*M+M] = S4_Error_current_Alpha;
assign B4[7*M+7*M+M+1] = S4_Error_current_Beta;
assign B4[7*M+7*M+M+2] = S4_Error_current_be1;
assign B4[7*M+7*M+M+3] = 0;
//end section_razor1 4
 
MUXS #(.N(N2))
muxs (
 .INA(B1),
 .INB(B2),
 .INC(B3),
 .IND(B4),
 .S1(S1),
 .S2(S2),
 .OUT(OUT_tmp)
 );

endmodule 