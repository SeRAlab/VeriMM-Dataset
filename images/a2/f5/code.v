module top_module(y, a, b);input [8:0] a, b;
	output [8:0] y;
	wire [8:0] y;
	reg [17:0] tempy;

	assign y = tempy[8:0];

	always @(a or b)
	begin
		tempy = a * b;
	end

endmodule