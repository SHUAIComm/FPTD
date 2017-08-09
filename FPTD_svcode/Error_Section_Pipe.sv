module Error_Section_Pipe (input logic Error_Alpha,
                      input logic Error_Beta,
                      input logic Error_Epsilon,
                      input logic Error_Ext,
                      output logic Error_Section);
                        
assign Error_Section = Error_Alpha | Error_Beta | Error_Epsilon | Error_Ext;

endmodule
