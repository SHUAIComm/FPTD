`timescale 1ns / 1ps

module divider (
  input      nReset,
  input      Clock,
  input      Sel,
  output     ClockOut
);

reg Clk1;
reg Clk2;

assign ClockOut = Sel ? Clk1 : Clk2;

always @ (posedge Clock, negedge nReset) begin
  if (!nReset) begin
    Clk1 <= 1'b0;
  end
  else begin
    Clk1 <= ~Clk1;
  end
end

always @ (posedge Clk1, negedge nReset) begin
  if (!nReset) begin
    Clk2 <= 1'b0;
  end
  else begin
    Clk2 <= ~Clk2;
  end
end

endmodule