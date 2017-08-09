`timescale 1ns / 1ps

module comparator #(parameter InN = 40, parameter OutN = 6)
                    (input nReset,
                     input Clock,
                     input logic signed [InN-1:0] A,
					           input logic signed [InN-1:0] B,
                     output logic signed [OutN-1:0] C);
					 
integer i;
logic signed [InN-1:0] tmp1;
logic signed [OutN-1:0] tmp2;
assign tmp1 = A^B; //find out the different bits

always_comb begin
  tmp2 = '0; // fill 0
  for(i=0;i<InN;i=i+1)
    tmp2 += tmp1[i]; //sum up all the different bits
end

always @ (posedge Clock, negedge nReset) begin
  if (!nReset) begin
    C <= 1'b0;
  end
  else begin
    C <= tmp2;
  end
end

endmodule