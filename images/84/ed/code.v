module top_module(
	input [3:0] x,
	input [3:0] y,
	output [7:0] out
	);reg equal;
	always @(x or y)
	begin
		if (x>y)
		begin
			equal = 1;
		end
		else 
		begin
			equal = 0;
		end
	end
	assign out[0]=equal;endmodule