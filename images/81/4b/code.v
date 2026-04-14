module top_module (
	input clk,
	input f, 
	output reg [2:0] v);always @(posedge clk)
		if (f)
			v <= 2;
		else if (v == 7)
			v <= 0;
		else
			v <= v + 1'b1;
			
endmodule