module CLK_MGM_razor2 (Clock_Sys, nReset, GlobalError, Clock_Even, Clock_Odd);
input Clock_Sys, nReset, GlobalError;
output Clock_Even,Clock_Odd;

wire ErrorQ;
wire Odd_nEven;
wire nOdd_Even;
wire nQDiv2;
wire QDiv2;
wire Tlow;

TIELBWP TieLow ( .ZN(Tlow) );


LNCNDQD1BWP ErrorLatch ( .EN(Clock_Sys), .D(GlobalError), .CDN(nReset), .Q(ErrorQ) ); 

DFCND1BWP Div2DFF (.D(Odd_nEven), .Q(QDiv2), .QN(nQDiv2), .CDN(nReset), .CP(Clock_Sys));
XOR2D0BWP XORError (.A1(ErrorQ), .A2(nQDiv2), .Z(Odd_nEven)); 
CKLNQD2BWP ClkGate_Odd  ( .CP(Clock_Sys), .E(Odd_nEven), .TE(Tlow), .Q(Clock_Odd) );
CKND1BWP Inverter ( .I(Odd_nEven), .ZN(nOdd_Even) );
CKLNQD2BWP ClkGate_Even ( .CP(Clock_Sys), .E(nOdd_Even), .TE(Tlow), .Q(Clock_Even) );


       
endmodule
