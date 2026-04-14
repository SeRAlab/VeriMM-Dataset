module top_module(
	T,
	clk,
	Q,
	rst
);input T, clk, rst;
	output reg Q;

	always @(posedge clk)
	begin
	if(~rst)
		Q <= 1'b0;
	else if(T)
		Q <= ~Q;
	end

endmodule