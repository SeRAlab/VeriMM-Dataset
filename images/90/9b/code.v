module value_module (
	input clk,
	input start, 
	output reg [3:0] value);always @(posedge clk)
		if (start)
			value <= value + 1;
		else
			value <= value;

endmodule