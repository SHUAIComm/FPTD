`timescale 1ns / 1ps

module InShiftReg #(parameter N1 = 200, parameter N2 = 7)
(
  input      nReset,
  input      Clock,
  input      SelShift,
  input      SelKeep,
  input      [N2-1:0] In,
  output     [N2-1:0][N1-1:0] Out
);

integer i;
reg [N1-1:0] Reg1;
reg [N1-1:0] Reg2;
reg [N1-1:0] Reg3;
reg [N1-1:0] Reg4;
reg [N1-1:0] Reg5;
reg [N1-1:0] Reg6;
reg [N1-1:0] Reg7;

assign Out[0] = Reg1;
assign Out[1] = Reg2;
assign Out[2] = Reg3;
assign Out[3] = Reg4;
assign Out[4] = Reg5;
assign Out[5] = Reg6;
assign Out[6] = Reg7;

always @ (posedge Clock, negedge nReset) begin
  if (!nReset) begin
    Reg1 <= 'b0;
    Reg2 <= 'b0;
    Reg3 <= 'b0;
    Reg4 <= 'b0;
    Reg5 <= 'b0;
    Reg6 <= 'b0;
	Reg7 <= 'b0;
  end
  else begin
    if (SelKeep)
      begin
        Reg1 <= Reg1;
        Reg2 <= Reg2;
        Reg3 <= Reg3;
        Reg4 <= Reg4;
        Reg5 <= Reg5;
        Reg6 <= Reg6;
		Reg7 <= Reg7;
      end
    else
      begin
        if (SelShift)
          begin
            Reg1 <= Reg2;
            Reg2 <= Reg3;
            Reg3 <= Reg4;
            Reg4 <= Reg5;
            Reg5 <= Reg6;
			Reg6 <= Reg7;
          end
        else
          begin
            Reg1[0] <= In[0];
            Reg2[0] <= In[1];
            Reg3[0] <= In[2];
            Reg4[0] <= In[3];
            Reg5[0] <= In[4];
            Reg6[0] <= In[5];
			Reg7[0] <= In[6];
            for (i=1; i<N1; i=i+1)
              begin
                Reg1[i] <= Reg1[i-1];
                Reg2[i] <= Reg2[i-1];
                Reg3[i] <= Reg3[i-1];
                Reg4[i] <= Reg4[i-1];
                Reg5[i] <= Reg5[i-1];
                Reg6[i] <= Reg6[i-1];
				Reg7[i] <= Reg7[i-1];
              end
          end
      end
  end
end

endmodule