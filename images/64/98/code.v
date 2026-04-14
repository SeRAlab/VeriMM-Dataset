module top_module(
	input clk,
	output [5:0] out);reg [5:0] fib_1 = 1;
reg [5:0] fib_2 = 1;

	always @(posedge clk) begin
		fib_1 <= fib_2;
		fib_2 <= fib_1 + fib_2;
	end

	assign out = fib_2;

endmodule