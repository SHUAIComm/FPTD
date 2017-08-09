`timescale 1ns / 1ps

module ErrorReg #(parameter FL = 104)
(
  input      nReset,
  input      Clock,
  input [FL-1:0] b1_error1,
  input [FL-1:0] b1_error2,
  input      Ready,
  input      Valid_Data,
  output reg KeepShift,
  output reg bitout1,
  output reg bitout2
);

integer i;
reg [FL-1:0] reg_error1;
reg [FL-1:0] reg_error2;
// reg [FL-1:0] reg1;
// reg [FL-1:0] reg2;
reg [7:0] count;

typedef enum logic {KEEP, SHIFT} state_enum;
state_enum state;

assign bitout1 = KeepShift ? reg_error1[0] : 0;
assign bitout2 = KeepShift ? reg_error2[0] : 0;

always @ (posedge Clock, negedge nReset)
begin
  if(!nReset)
  begin
    state <= KEEP;
	reg_error1 <= 0;
	reg_error2 <= 0;
	// reg1 <= 0;
	// reg2 <= 0;
	count <= 0;
	KeepShift <=0;
  end
  else
  begin
	case (state)
	KEEP: begin
			if(Valid_Data && Ready)
			begin
				state <= SHIFT;
				// reg1 <= b1_error1;
				// reg2 <= b1_error2;
				reg_error1 <= b1_error1;
				reg_error2 <= b1_error2;
				KeepShift <= 1;
				count <= 0;
			end
			else
			begin
				state <= KEEP;
				//count = count+1;
				reg_error1 <= reg_error1;
				reg_error2 <= reg_error2;
			end
		  end
	SHIFT: begin
	         // if(Valid_Data && Ready)
			 // begin
				// reg1 <= b1_error1;
				// reg2 <= b1_error2;
			 // end
			 if(count == FL-1)
			 begin
				state <= KEEP;
				KeepShift <= 0;
				//reg_error1 <= reg1;
				//reg_error2 <= reg2;
				count <= 0;
			 end
			 else
			 begin
				for (i=1; i<FL; i=i+1)
				begin
					reg_error1[FL-i-1] <= reg_error1[FL-i];
					reg_error2[FL-i-1] <= reg_error2[FL-i];
				end
				count <= count+1;
				state <= SHIFT;
			 end
	       end
    endcase
  end
end

endmodule
