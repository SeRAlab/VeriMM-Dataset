module fibonacci_generator(
	input clk,
	input reset,
	output reg [15:0] fib1,
	output reg [15:0] fib2);always @(posedge clk)
	if (reset) begin
		fib1 <= 16'd1;
		fib2 <= 16'd1;
	end else begin
		reg [15:0] next_fib;
		next_fib = fib1 + fib2;
		fib1 <= fib2;
		fib2 <= next_fib;
	end

endmodule