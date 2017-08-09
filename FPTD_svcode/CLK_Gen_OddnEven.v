module CLK_Gen_OddnEven (Clock_Sys, nReset, Clock_Even, Clock_Odd);
input Clock_Sys, nReset;
output Clock_Even,Clock_Odd;

wire Odd_nEven;
wire nOdd_Even;
wire Tlow;

TIELBWP TieLow ( .ZN(Tlow) );

DFCND1BWP Div2DFF (.D(Odd_nEven), .Q(nOdd_Even), .QN(Odd_nEven), .CDN(nReset), .CP(Clock_Sys));
CKLNQD2BWP ClkGate_Odd  ( .CP(Clock_Sys), .E(Odd_nEven), .TE(Tlow), .Q(Clock_Odd) );
CKLNQD2BWP ClkGate_Even ( .CP(Clock_Sys), .E(nOdd_Even), .TE(Tlow), .Q(Clock_Even) );


       
endmodule
