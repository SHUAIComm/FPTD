module EstimatedBit #(parameter N = 6, parameter M = 6)
                (input logic Clock,
                 input logic nReset,
                 input logic nClear,
                 input logic Enable,
                 input logic signed [M-1:0] ba1,
                 input logic signed [N-1:0] ba3,
                 input logic signed [M-1:0] be1,
                 input logic b1_ideal,
                 output logic b1_error);
           
logic signed [M+1:0] AprioriLLRs;
assign AprioriLLRs = ba1 + ba3 + be1;

always_ff@(posedge Clock, negedge nReset, negedge nClear)
    if(!nReset || !nClear)
        b1_error <= 1;
    // else if (!nClear)
        // b1_error <= 1;
    else if(Enable)
        b1_error <= b1_ideal ^ (~AprioriLLRs[M+1]);
         
endmodule
