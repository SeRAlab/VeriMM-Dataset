module top_module( clk, set, d, q );// synthesis attribute keep_hierarchy dffs_37 "true";
	input clk;
	input set;
	input [36:0] d;
	output [36:0] q;
	reg [36:0] q;
	// synopsys translate_off
`ifdef RANDOM_INIT
	initial
	$random_init("q");
`endif
`ifdef CHK_RESET_EOS
	assert_quiescent_state #(0,1,0, 
	"***ERROR ASSERT: set still asserted at end of simulation")
	a0(.clk(clk),.reset_n(1'b1), .state_expr(set),
	.check_value(1'b0), .sample_event(1'b0));
`endif
	// synopsys translate_on
	always @(posedge clk) begin
	if (set)
	q <= ~(37'b0);
	else
	q <= d;
	end
endmodule