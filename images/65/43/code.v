module top_module( clk, ld, rst, d, q );// synthesis attribute keep_hierarchy dffl_18 "true";
	input clk;
	input ld;
	input rst;
	input [17:0] d;
	output [17:0] q;
	reg [17:0] q;
	// synopsys translate_off
`ifdef RANDOM_INIT
	initial
	$random_init("q");
`endif
	// synopsys translate_on
	always @(posedge clk) begin
		if (rst == 0) begin
			q <= 0;
		end
		else if (ld == 1) begin
			q <= d;
		end
	end
endmodule