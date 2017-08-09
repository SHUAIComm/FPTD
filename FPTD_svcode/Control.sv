module Control #(parameter DCmax=256, parameter LoadLLRs=1) 
              (input logic Clock,
               input logic nReset,
               input logic Start,
               input logic unsigned [6:0] Error_Count,
               output logic nClear,
               output logic Enable_Odd,
               output logic Enable_Even,
               output logic Enable_Error_Counter,
               output logic Enable_Term,
               output logic Valid_Data,
               output logic Ready);

// State definition and state variable as parameters
// parameter IDLE = 2'b00;
// parameter LOAD_LLRS = 2'b01;
// parameter DECODE = 2'b11;
// parameter FINISH = 2'b10;
// logic [1:0] state;

// State definition and state variable as enum type
typedef enum logic[2:0] {IDLE, LOAD_LLRS, DECODE, EARLY_STOP, MAX_DCs, FINISH} state_enum;
state_enum state;
 

         
// Internal logic definition
logic unsigned [9:0] DC;
         
always_ff@(posedge Clock, negedge nReset)
    if(!nReset)
    begin
        state <= IDLE;
        Enable_Odd <= 0;
        Enable_Even <= 0;
        Enable_Error_Counter <= 0;
        Enable_Term <= 0;
        Valid_Data <= 0;
        Ready <= 0;
        nClear <= 1;
        DC <= 0;
    end
    else
        case (state)
            // Wait for Start signal to be asserted
            IDLE:
            begin
                Enable_Odd <= 0;
                Enable_Even <= 0;
                Enable_Error_Counter <= 0;
                Enable_Term <= 0;
                Valid_Data <= 0;
                Ready <= 0;
                nClear <= 1;
                DC <= 0;
                if (!Start)
                    state <= IDLE;
                else
                    state <= LOAD_LLRS;
            end
            
            // Load all LLRs from main I/Os
            LOAD_LLRS:
            begin
                Enable_Even <= 0;
                Valid_Data <= 0;
                Ready <= 0;
                nClear <= 1;
                if(DC == LoadLLRs-1)
                begin
                    state <= DECODE;
                    Enable_Odd <= 1;
                    Enable_Term <= 1;
                    Enable_Error_Counter <= 1;
                    DC <= 0;
                end
                else
                begin
                    state <= LOAD_LLRS;
                    Enable_Odd <= 0;
                    Enable_Term <= 0;
                    Enable_Error_Counter <= 0;
                    DC <= DC + 1;
                end
            end
            // Perform decoding process
            // Enable Odd/Even blocks in alternate clock cycles
            // Perform this for DCmax clock cycles
            DECODE:
            begin
                //Ready <= 0;
                nClear <= 1;
                if(Error_Count == 0)
                begin
                    state <= EARLY_STOP;
                    Enable_Odd <= 0;
                    Enable_Even <= 0;
                    Enable_Term <= 0;
                    Enable_Error_Counter <= 0;
                    Valid_Data <= 1;
                    DC <= DC + 1 ;
                end 
                else
                    begin
					if(DC == DCmax-3)
						Ready <= 1;
					if(DC == DCmax-1)
                    begin
                        state <= MAX_DCs;
                        Enable_Odd <= 0;
                        Enable_Even <= 0;
                        Enable_Term <= 0;
                        Enable_Error_Counter <= 1;
                        Valid_Data <= 1;
						Ready <= 1;
                        DC <= 0;
                    end 
                    else 
                    begin
                        state <= DECODE;
                        Enable_Error_Counter <= 1;
                        // Enable termination blocks only for 3 DCs
                        if (DC < 2) 
                            Enable_Term <= 1;
                        else
                            Enable_Term <= 0;
                        // Enable Error counter after the first 2 DCs    
                        if(DC >= 1)
                        begin
                            Valid_Data <= 1;
                        end
                        else
                        begin
                            Valid_Data <= 0;
                        end
                        // Alternate Odd and Even     
                        if(DC%2==1)
                        begin
                            Enable_Odd <= 1;
                            Enable_Even <= 0;   
                        end                        
                        else
                        begin
                            Enable_Odd <= 0;
                            Enable_Even <= 1; 
                        end
                        
                        DC <= DC + 1; 
                    end
					end
            end
            
            EARLY_STOP:
            begin
                Enable_Odd <= 0;
                Enable_Even <= 0;
                Enable_Term <= 0;
                Enable_Error_Counter <= 0;
                Valid_Data <=1;
                //Ready <= 0;
                nClear <= 1;
				if(DC == DCmax-3)
					Ready <= 1;
                if(DC == DCmax-1)
                begin
                    state <= MAX_DCs;
					Ready <= 1;
                    DC <= 0;
                end 
                else
                begin
                    state <= EARLY_STOP;
                    DC <= DC + 1;
                end
            end
            
            MAX_DCs:
            begin
                Enable_Odd <= 0;
                Enable_Even <= 0;
                Enable_Term <= 0;
                Enable_Error_Counter <= 0;
                if(DC==1)
                begin
                    state <= FINISH;
                    Valid_Data <= 0;
                    //Ready <= 1;
                    nClear <= 0;
                    DC <= 0;
                end
                else
                begin
                    state <= MAX_DCs;
                    Valid_Data <= 1;
                    Ready <= 1;
                    nClear <= 1;
                    DC <= DC + 1;
                end
            end
            // Output decoded bits 
            FINISH:
            begin
                state <= IDLE;
                Enable_Odd <= 0;
                Enable_Even <= 0;
                Enable_Error_Counter <= 0;
                Enable_Term <= 0;
                Valid_Data <= 0;
                Ready <= 1;
                nClear <= 1;
                DC <= 0;
            end
            
            // Default state is IDLE
            default:
            begin
                state <= IDLE;
                Enable_Odd <= 0;
                Enable_Even <= 0;
                Enable_Error_Counter <= 0;
                Enable_Term <= 0;
                Valid_Data <= 0;
                Ready <= 0;
                nClear <= 1;
                DC <= 0;
            end
        endcase
            
                
endmodule
