module top_module( clk, reset, d, q );// synthesis attribute keep_hierarchy dffc_keep_3 "true";
	// synthesis attribute equivalent_register_removal dffc_keep_3 "no";
	// synthesis attribute shift_extract dffc_keep_3 "no";
	// synthesis attribute shreg_extract dffc_keep_3 "no";
	input clk;
	input reset;
	input [2:0] d;
	// synthesis attribute keep q "true";
	output reg [2:0] q; // changed to 'reg' since q is driven inside always block.
	
	// synopsys translate_off
`ifdef CHK_RESET_EOS
	assert_quiescent_state #(0,1,0, 
	"***ERROR ASSERT: reset still asserted at end of simulation")
	a0(.clk(clk),.reset_n(1'b1), .state_expr(reset),
	.check_value(1'b0), .sample_event(1'b0));
`endif
	// synopsys translate_on

	always @(posedge clk or posedge reset) begin
		if (reset) begin
			q <= 3'b101; // Assign the fixed value on reset
		end else begin
			q <= d; // Assign d to q on the clock edge
		end
	end
endmodule