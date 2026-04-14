module sync_down_counter_with_load(
	input clk,
	input load,
	input [2:0] load_val,
	output reg [2:0] q);initial
		q = 3'b111;
		
	always @(posedge clk)
		if (load)
			q <= load_val;
		else
			q <= q - 1;
	
endmodule