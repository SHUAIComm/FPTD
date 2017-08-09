`timescale 1ns / 1ps

module OutShiftReg #(parameter N1 = 76, parameter N2 = 7)
(
  input      nReset,
  input      Clock,
  input      SelShift,
  input      SelKeep,
  input      [N1-1:0] In,
  output     [N2-1:0] Out
);

integer i, j;
genvar x;
reg [N2-1:0][N1-1:0] Reg;

for (x=0; x<N2; x=x+1)
  begin
    assign Out[x] = Reg[x][N1-1];
  end

always @ (posedge Clock, negedge nReset) begin
  if (!nReset) begin
    Reg <= 'b0;
  end
  else begin
    if (SelKeep)
      begin
        Reg <= Reg;
      end
    else
      begin
        if (!SelShift)
          begin
            Reg[N2-1] <= In;
            for (i=1; i<N2; i=i+1)
              begin
                Reg[N2-i-1] <= Reg[N2-i];
              end 
          end
        else
          begin
            for (j=0; j<N2; j=j+1)
              begin
                for (i=1; i<N1; i=i+1)
                  begin
                    Reg[j][i] <= Reg[j][i-1];
                  end
              end
          end
      end
  end
end

endmodule