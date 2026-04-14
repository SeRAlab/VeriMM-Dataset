module top_module( clk, reset, init, d, q );// synthesis attribute keep_hierarchy dffsi_4 "true";
	input clk;
	input reset;
	input [3:0] init;
	input [3:0] d;
	output [3:0] q;
	reg [3:0] q;
	// synopsys translate_off
`ifdef RANDOM_INIT
	initial
	$random_init("q");
`endif
`ifdef CHK_RESET_EOS
	assert_quiescent_state #(0,1,0, 
	"***ERROR ASSERT: reset still asserted at end of simulation")
	a0(.clk(clk),.reset_n(1'b1), .state_expr(reset),
	.check_value(1'b0), .sample_event(1'b0));
`endif
	// synopsys translate_on
	always @(posedge clk) begin
	if (reset)
	q <= init;
	else
	q <= d;
	end
endmodule