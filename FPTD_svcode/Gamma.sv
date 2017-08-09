// `timescale 1ns/10ps
module Gamma #(parameter N = 5, parameter M = 6)
              (input logic signed  [M-1:0] ba1,
               input logic signed  [N-1:0] ba2,
               input logic signed  [N-1:0] ba3,
               output logic signed [M:0] ba1ba3,
               output logic signed [M:0] ba1ba2ba3);

// Scaled ba1
logic signed [M+1:0] ba1_x3;
logic signed [M-1:0] ba1_scaled;
             
// Temporal addition results      
logic signed [M+1:0] ba1ba2ba3_temp;

// Scaling of ba1: 0.75*ba1 = 3*ba1/4
// assign ba1_x3 = $signed({ba1,1'b0}) + ba1;
// assign ba1_scaled = $signed(ba1_x3[M+1:2]); 

assign ba1_x3 = (ba1 <<< 1) + ba1;
assign ba1_scaled = ba1_x3 >>> 2; 

// Additions of ba1, ba2 and ba3
assign ba1ba3   = ba1_scaled + ba3;
assign ba1ba2ba3_temp = ba1ba3 + ba2;

// Clipping of ba1ba3 and ba1ba2ba3
// BitClip #(.N_In(M+1),.N_Out(M)) Clip_ba1ba3   (.IN(ba1ba3_temp),  .OUT(ba1ba3));
generate
    if(M <= N)
    begin:Clipping
        BitClip #(.N_In(M+2),.N_Out(M+1)) Clip_ba1ba2ba3 (.IN(ba1ba2ba3_temp),.OUT(ba1ba2ba3));
    end
    else
    begin:Clipping
        assign ba1ba2ba3 = ba1ba2ba3_temp;
    end
    endgenerate   
    
endmodule

