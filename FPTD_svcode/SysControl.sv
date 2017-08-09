`timescale 1ns / 1ps

module SysControl #(parameter N1 = 200, parameter N2 = 7)
(
  input      nReset,
  input      Clock,
  input      Mode,
  input      Go,
  input      Enable_f,
  input      Sel_f,
  output reg Start,
  output reg Start2,
  output reg TestReady,
  output reg Inkeep,
  output reg Inshift,
  output reg Outkeep,
  output reg Outshift,
  output reg SelCLK
);

logic unsigned [9:0] count;

typedef enum logic[1:0] {IDLE, PROCESS, NEXT, FINISH} state_enum;
state_enum state;

typedef enum logic[2:0] {WAIT, DATA, TOFAST, TEST, TOSLOW} state_enum1;
state_enum1 state1;

//assign SelCLK = Sel_f;

always @ (posedge Clock, negedge nReset)
begin
  if(!nReset)
  begin
    state <= IDLE;
	state1 <= WAIT;
    Inkeep <= 1;
    Inshift <= 0;
    Outkeep <= 1;
    Outshift <= 0;
    SelCLK <= 0;
    count <= 0;
    Start <= 0;
	Start2 <= 0;
	TestReady <= 0;
  end
  else
  begin
    if (Mode)
      begin : MODE1
        case (state)
        IDLE: begin
                if (Go)
                  begin
                  state <= PROCESS;
                  Start <= 1;
				  Inkeep <= 0;
                  end
                else
                  state <= IDLE;
              end
        PROCESS: begin
                   if (count != (N1-1+1*Enable_f)*(1+(2*(2-Sel_f)-1)*Enable_f)) //1+(2*(2-Sel_f)-1)*Enable_f
                     begin
                       count <= count + 1;
                       state <= PROCESS;
                       Inkeep <= 0;
                       Inshift <= 0;
                       Start <= 0;
                     end
                   else
                     begin
                       count <= 0;
                       state <= NEXT;
                       Inkeep <= 1;
                       Inshift <= 0;
                       Start <= 0;
                     end
                 end
        NEXT: begin
                if (count != 5)
				begin
					state <= NEXT;
					count <= count + 1;
				end
				else
				begin
					state <= IDLE;
					count <= 0;
				end
              end
        default: begin
                   state <= IDLE;
                 end
        endcase
      end
    else
      begin : MODE2
        case (state1)
        WAIT: begin
                if (Go)
                  begin
                  state1 <= DATA;
                  Start2 <= 1;
				  if(Enable_f)
					SelCLK <= 1;
				  else
					SelCLK <= 0;
                  end
                else
                  state1 <= WAIT;
              end
        DATA: begin
                   if (count != (N1-1+1*Enable_f)*(1+(2*(2-Sel_f)-1)*Enable_f))
                     begin
                       count <= count + 1;
                       state1 <= DATA;
                       Inkeep <= 0;
                       Inshift <= 0;
					   Outkeep <= 0;
                       Outshift <= 1;
                       Start2 <= 0;
                     end
                   else
                     begin
                       count <= 0;
                       state1 <= TOFAST;
                       Inkeep <= 1;
                       Inshift <= 0;
					   Outkeep <= 0;
                       Outshift <= 0;
                       Start2 <= 0;
					   TestReady <= 1;
					   if(Enable_f)
						  SelCLK <= 0;
                     end
                 end
        TOFAST: begin
                if (count != 3)
				begin
					state1 <= TOFAST;
					TestReady <= 0;
					count <= count + 1;
				end
				else
				begin
					state1 <= TEST;
					Inkeep <= 0;
                    Inshift <= 1;
					count <= 0;
				end
              end
        TEST: begin
                if (count != 7)
				begin
					state1 <= TEST;
					count <= count + 1;
					Inkeep <= 0;
                    Inshift <= 1;
					Outkeep <= 0;
                    Outshift <= 0;
				end
				else
				begin
					state1 <= TOSLOW;
					count <= 0;
					Inkeep <= 0;
                    Inshift <= 0;
					Outkeep <= 1;
                    Outshift <= 0;
				end
              end
		TOSLOW: begin
                if (count != 3)
				begin
					state1 <= TOSLOW;
					count <= count + 1;
				end
				else
				begin
					state1 <= WAIT;
					count <= 0;
					if(Enable_f)
						SelCLK <= 1;
				end
              end
		default: begin
                   state1 <= WAIT;
                 end
        endcase
      end
  end
end

endmodule
