module top_module(
	input wire inclk0,
	output reg c0 = 0,
	output reg c1 = 1,
	output reg c2 = 0
);always #2 c0 = ~c0; 
always #20 c1 = ~c1; 
always #10417 c2 = ~c2;

endmodule