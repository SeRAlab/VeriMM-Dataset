module top_module (
	input clk,
	input u,
	input v,
	output reg w,
	output reg state);reg m;
	always @(posedge clk)
		m <= u&v | m&~u;

	assign w = m;
	assign state = m;
			
endmodule