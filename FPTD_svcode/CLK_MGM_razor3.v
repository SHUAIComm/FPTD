module CLK_MGM_razor3 (Clock_Sys, nReset, GlobalError,  Clock_Even, Clock_Odd);
input Clock_Sys, nReset, GlobalError;
output Clock_Even, Clock_Odd;
                       
wire ClearError, Clock_Enabled, ErrorQ, nErrorQ, nQDiv2, QDiv2, Tlow, Odd_nEven ;

TIELBWP TieLow ( .ZN(Tlow) );         
LNCND1BWP ErrorLatch ( .EN(Clock_Sys), .D(GlobalError), .Q(ErrorQ), .QN(nErrorQ), .CDN(ClearError)); 
DFCND1BWP ErrorDFF   ( .CP(Clock_Sys), .CDN(nReset), .D(ErrorQ),  .QN(ClearError), .Q(nClearError) ); 
CKLNQD2BWP ClkGate_Div2  ( .CP(Clock_Sys), .E(nErrorQ), .TE(Tlow), .Q(Clock_Enabled) );

DFNCND1BWP Div2DFF   ( .CPN(Clock_Enabled), .CDN(nReset), .D(Odd_nEven), .QN(Odd_nEven), .Q(nOdd_nEven) ); 
CKLNQD2BWP ClkGate_Odd  ( .CP(Clock_Enabled), .E(Odd_nEven), .TE(Tlow), .Q(Clock_Odd) );
CKLNQD2BWP ClkGate_Even ( .CP(Clock_Enabled), .E(nOdd_nEven), .TE(Tlow), .Q(Clock_Even) );
       
endmodule
