module BitClip #(parameter N_In=9, 
                 parameter N_Out=6)
                (output logic signed [N_Out-1:0] OUT, 
                 input logic signed  [N_In-1:0] IN);
// Method 1
//assign OUT = ^IN[N_In-1:N_Out-1] ? {IN[N_In-1],{(N_Out-1){~IN[N_In-1]}}} : IN[N_Out-1:0];

// Method 2
/*
logic signed [N_Out-1:0] LB;
logic signed [N_Out-1:0] UB;

assign OUT = ^IN[N_In-1:N_Out-1] ? (IN[N_In-1] ? LB: UB) : IN[N_Out-1:0];
*/
// ************************************************ 
// Method 3

logic signed [N_Out-1:0] LB;
logic signed [N_Out-1:0] UB;

always_comb
begin
	UB = $signed({1'sb0, {(N_Out-1) {1'b1}}});
	LB = $signed({1'sb1, {(N_Out-1) {1'b0}}});	    
	
	if (IN > UB)
	  OUT = UB;
	else if (IN < LB)
	  OUT = LB;
	else
   	  OUT = IN;
end

// ************************************************ 
// Method 4
// logic signed [N_Out-1:0] LB;
// logic signed [N_Out-1:0] UB;

// always_comb
// begin
	// UB = {1'b0, {(N_Out-1) {1'b1}}};
	// LB = {1'b1, {(N_Out-1) {1'b0}}};	    
	
// end

// assign OUT = ~(&IN[N_In-1:N_Out-1] | &(~IN[N_In-1:N_Out-1])) ? (IN[N_In-1] ? LB: UB) : IN[N_Out-1:0];
// assign OUT = ~(&IN[N_In-1:N_Out-1] | &(~IN[N_In-1:N_Out-1])) ? {IN[N_In-1],{(N_Out-1){~IN[N_In-1]}}} : IN[N_Out-1:0];
// assign OUT = ~(&IN[N_In-1:N_Out-1] | &(~IN[N_In-1:N_Out-1])) ? (IN[N_In-1] ? {1'b1, {(N_Out-1) {1'b0}}}: {1'b0, {(N_Out-1) {1'b1}}}) : IN[N_Out-1:0];


endmodule
