module fan_freq(
	clk,
	fan,
	led
);

parameter DUR_BITS = 27;

input  clk;
output fan;
output [3:0] led;


reg [(DUR_BITS-1):0] cnt;
always @ (posedge clk)
begin
	cnt <= cnt + 1;
end

assign fan = cnt[DUR_BITS-8];
assign led[3] = cnt[DUR_BITS-4];
assign led[2] = cnt[DUR_BITS-3];
assign led[1] = cnt[DUR_BITS-2];
assign led[0] = cnt[DUR_BITS-1];


endmodule
