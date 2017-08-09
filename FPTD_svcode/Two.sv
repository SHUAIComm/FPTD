/* FPTD CORE AND CONTROL */
module Two #(parameter FL = 104, parameter DCmax = 256, parameter N = 4, parameter M = 5) 
                             (input logic Clock, 
                              input logic nReset, 
                              input logic Start,
                              input logic [FL-1:0] b1_ideal,
                              input logic signed [2:0][N-1:0] but1, 
                              input logic signed [FL+2:0][N-1:0] bua2, 
                              input logic signed [FL-1:0][N-1:0] bua3, 
                              input logic signed [2:0][N-1:0] blt1, 
                              input logic signed [FL+2:0][N-1:0] bla2, 
                              output logic Ready1,
                              output logic Valid_Data1,
                              output logic unsigned [5:0] DOut1,
                              output logic Ready2,
                              output logic Valid_Data2,
                              output logic unsigned [5:0] DOut2); 


FPTD #(.FL(FL), .DCmax(DCmax), .N(N), .M(M)) 
FPTD1            (.Clock(Clock), 
                  .nReset(nReset), 
                  .Start(Start), 
                  .b1_ideal(b1_ideal),
                  .but1(but1), 
                  .bua2(bua2), 
                  .bua3(bua3), 
                  .blt1(blt1), 
                  .bla2(bla2), 
                  .Ready(Ready1),
                  .Valid_Data(Valid_Data1),
                  .Errors(DOut1));
				  
FPTD_Pipe_razor1 #(.FL(FL), .DCmax(DCmax), .N(N), .M(M)) 
FPTD2            (.Clock(Clock), 
                  .nReset(nReset), 
                  .Start(Start), 
                  .b1_ideal(b1_ideal),
                  .but1(but1), 
                  .bua2(bua2), 
                  .bua3(bua3), 
                  .blt1(blt1), 
                  .bla2(bla2), 
                  .Ready(Ready2),
                  .Valid_Data(Valid_Data2),
                  .Errors(DOut2));


endmodule
