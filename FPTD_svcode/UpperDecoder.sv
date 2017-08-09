module UpperDecoder #(parameter FL =  104, parameter N = 6, parameter M = 6)
                    (input logic Clock,
                     input logic nReset,
                     input logic nClear,
                     input logic Enable_Odd,
                     input logic Enable_Even,
                     input logic Enable_Term,
                     input logic Enable_Error_Counter,
                     input logic [FL-1:0] b1_ideal,
                     input logic signed [FL-1:0][M-1:0] ba1,
                     input logic signed [2:0][N-1:0] bt1,
                     input logic signed [FL+2:0][N-1:0] ba2,
                     input logic signed [FL-1:0][N-1:0] ba3,
                     output logic signed [FL-1:0][M-1:0] be1,
                     output logic unsigned [6:0] Error_Count,
                     output logic unsigned [6:0] Error_Count_buff,
					 output logic [FL-1:0] b1_error);

/* ***** Internal signals ***** */
// Alphas and Betas
logic signed [FL-1:0][7:1][M-1:0]alpha_in;  
logic signed [FL-2:0][7:1][M-1:0]alpha_out;                     
logic signed [FL+2:0][7:1][M-1:0]beta_in;                      
logic signed [FL+2:1][7:1][M-1:0]beta_out;   

// Alphas Section 1 (-inf)
assign alpha_in[0][1] = $signed({1'b1,{(M-1){1'b0}}});
assign alpha_in[0][2] = $signed({1'b1,{(M-1){1'b0}}});
assign alpha_in[0][3] = $signed({1'b1,{(M-1){1'b0}}});
assign alpha_in[0][4] = $signed({1'b1,{(M-1){1'b0}}});
assign alpha_in[0][5] = $signed({1'b1,{(M-1){1'b0}}});
assign alpha_in[0][6] = $signed({1'b1,{(M-1){1'b0}}});
assign alpha_in[0][7] = $signed({1'b1,{(M-1){1'b0}}});

// Betas Section N+3  (-inf)
assign beta_in[FL+2][1] = $signed({1'b1,{(M-1){1'b0}}});
assign beta_in[FL+2][2] = $signed({1'b1,{(M-1){1'b0}}});
assign beta_in[FL+2][3] = $signed({1'b1,{(M-1){1'b0}}});
assign beta_in[FL+2][4] = $signed({1'b1,{(M-1){1'b0}}});
assign beta_in[FL+2][5] = $signed({1'b1,{(M-1){1'b0}}});
assign beta_in[FL+2][6] = $signed({1'b1,{(M-1){1'b0}}});
assign beta_in[FL+2][7] = $signed({1'b1,{(M-1){1'b0}}});

// Bit errors
//logic [FL-1:0] b1_error;
 
/* ***** Decoding sections ***** */
generate
genvar sec_index;
    for(sec_index=0; sec_index<FL+3; sec_index=sec_index+1)
    begin:Gen_Section
         
                 
        // Forward Recursion ALPHA
        if(sec_index<FL-1) // alpha N is not necessary
        begin:ForwardRecursion  
            assign alpha_in[sec_index+1] = alpha_out[sec_index];                            
        end
        
        // Backward Recursion BETA
        if(sec_index<FL+2)
        begin:BackwardRecursion
            assign beta_in[sec_index] = beta_out[sec_index+1];                           
        end
        // Instantiate individual sections 
        if(sec_index==0) // Instantiate First section => S=1; Betas not needed
        begin:Section_First
        Section_NoBeta #(.N(N),.M(M))
        Section         (.Clock(Clock),
                         .nReset(nReset),
                         .nClear(nClear),
                         .Enable(Enable_Odd),
                         .b1_ideal(b1_ideal[sec_index]),
                         .ba1(ba1[sec_index]),
                         .ba2(ba2[sec_index]),
                         .ba3(ba3[sec_index]),
                         .alpha_in(alpha_in[sec_index]), 
                         .beta_in(beta_in[sec_index]),
                         .alpha_out(alpha_out[sec_index]),
                         .be1(be1[sec_index]),
                         .b1_error(b1_error[sec_index]));
        end
        else if(sec_index==FL-1) // Instantiate Last Section => S=N; Alphas not needed
        begin:Section_Last
        Section_NoAlpha #(.N(N),.M(M))
        Section         (.Clock(Clock),
                         .nReset(nReset),
                         .nClear(nClear),
                         .Enable(Enable_Even),
                         .b1_ideal(b1_ideal[sec_index]),
                         .ba1(ba1[sec_index]),
                         .ba2(ba2[sec_index]),
                         .ba3(ba3[sec_index]),
                         .alpha_in(alpha_in[sec_index]), 
                         .beta_in(beta_in[sec_index]),
                         .beta_out(beta_out[sec_index]),
                         .be1(be1[sec_index]),
                         .b1_error(b1_error[sec_index]));
        end
        else if(sec_index>=FL) // Instantiate Termination Sections => S={N+1, N+2, N+3}; Only Betas needed
        begin:Section_Term
        Section_Termination #(.N(N),.M(M))
        Section_Termination  (.Clock(Clock),
                              .nReset(nReset),
                              .nClear(nClear),
                              .Enable(Enable_Term),
                              .ba1(bt1[sec_index-FL]),
                              .ba2(ba2[sec_index]),
                              .beta_in(beta_in[sec_index]),
                              .beta_out(beta_out[sec_index]));
        end
        else if(sec_index%2==0) // Instantiate Odd Section (numbering starting at 1) => S={3,5,7,...N-1}
        begin:Section
        Section #(.N(N),.M(M))
        Section  (.Clock(Clock),
                  .nReset(nReset),
                  .nClear(nClear),
                  .Enable(Enable_Odd),
                  .b1_ideal(b1_ideal[sec_index]),
                  .ba1(ba1[sec_index]),
                  .ba2(ba2[sec_index]),
                  .ba3(ba3[sec_index]),
                  .alpha_in(alpha_in[sec_index]), 
                  .beta_in(beta_in[sec_index]),
                  .alpha_out(alpha_out[sec_index]),
                  .beta_out(beta_out[sec_index]),
                  .be1(be1[sec_index]),
                  .b1_error(b1_error[sec_index]));
        end
        else    // Instantiate Even Section (numbering starting at 1) => S={2,4,6,...N-2}
        begin:Section
        Section #(.N(N),.M(M))
        Section  (.Clock(Clock),
                  .nReset(nReset),
                  .nClear(nClear),
                  .Enable(Enable_Even),
                  .b1_ideal(b1_ideal[sec_index]),
                  .ba1(ba1[sec_index]),
                  .ba2(ba2[sec_index]),
                  .ba3(ba3[sec_index]),
                  .alpha_in(alpha_in[sec_index]), 
                  .beta_in(beta_in[sec_index]),
                  .alpha_out(alpha_out[sec_index]),
                  .beta_out(beta_out[sec_index]),
                  .be1(be1[sec_index]),
                  .b1_error(b1_error[sec_index]));
        end
    end
endgenerate

/* ***** Error Counter ***** */
Error_Counter #(.FL(FL))
Error_Counter  (.Clock(Clock),
                .nReset(nReset),
                .Enable(Enable_Error_Counter),
                .nClear(nClear),
                .b1_error(b1_error),
                .Error_Count(Error_Count),             
                .Error_Count_buff(Error_Count_buff));             
endmodule
