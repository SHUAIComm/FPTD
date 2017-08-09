module Error_Counter #(parameter FL = 104)
                      (input logic Clock,
                       input logic nReset,
                       input logic Enable,
                       input logic nClear,
                       input logic [FL-1:0] b1_error,
                       output logic [6:0] Error_Count,
                       output logic [6:0] Error_Count_buff);
logic [6:0] Errors;
always_comb
    begin
    Errors = 0;
        for(int i=0; i<FL; i=i+1)
            Errors = Errors + b1_error[i];
    end
                       
always_ff@(posedge Clock, negedge nReset, negedge nClear)
    if(!nReset || !nClear)
    begin
        Error_Count <= FL;
        Error_Count_buff <= FL;
    end
    else if(Enable)
    begin
        Error_Count <= Errors;
        Error_Count_buff <= Error_Count;
    end
    // else if(!nClear)
    // begin
        // Error_Count <= FL;
        // Error_Count_buff <= FL;
    // end

endmodule
