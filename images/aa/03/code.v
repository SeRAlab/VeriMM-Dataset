module top_module(
	input wire clk,
	input wire reset,
	input wire enable,
	output wire out
);reg [2:0] cnt = 3'b0;
	always @(posedge clk)
		if(reset)
			cnt <= 3'b0;
		else if(enable)
			cnt <= cnt + 1'b1;
	assign out = cnt[2];
endmodule