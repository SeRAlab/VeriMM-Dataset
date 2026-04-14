module top_module (
	input clk,
	input a,
	input b,
	output reg c,
	output reg state);reg i;
	always @(posedge clk)
		i <= a&b | a&i | b&i;
	
	assign c = a^b^i;
	assign state = i;
			
endmodule