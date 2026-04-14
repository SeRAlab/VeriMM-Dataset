module top_module(a, b, ci, co, y);input  [7:0] a, b;
	input        ci;
	output       co;
	output [7:0] y;
	reg    [7:0] y;
	reg          co;
	
	always@(a or b or ci) begin
		{co, y} <= a - b - ci;
	end
	
endmodule