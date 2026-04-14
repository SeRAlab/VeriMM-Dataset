module top_module(
	output reg Q,
	input C,
	input E,
	input R,
	input D
);always @(negedge C) begin
		if (R) begin
			Q <= 1'b0;
		end
		else if (E) begin
			Q <= D;
		end
	end

`ifdef ICE40_HX
	specify
		// Setup time for D input
		$setup(D, negedge C &&& E && !R, 470 - 449);

		// Setup time for E input
		$setup(E, negedge C, 0);

		// Setup time for R input
		$setup(R, negedge C &&& E, 203);

		// Hold time for Q output when E and R are high
		if (E && R) (negedge C => (Q : 1'b0)) = 540;

		// Hold time for Q output when E is high and R is low
		if (E && !R) (negedge C => (Q : D)) = 540;
	endspecify
`endif

`ifdef ICE40_LP
	specify
		// Setup time for D input
		$setup(D, negedge C &&& E && !R, 693 - 662);

		// Setup time for E input
		$setup(E, negedge C, 0);

		// Setup time for R input
		$setup(R, negedge C &&& E, 299);

		// Hold time for Q output when E and R are high
		if (E && R) (negedge C => (Q : 1'b0)) = 796;

		// Hold time for Q output when E is high and R is low
		if (E && !R) (negedge C => (Q : D)) = 796;
	endspecify
`endif

`ifdef ICE40_U
	specify
		// Setup time for D input
		$setup(D, negedge C &&& E, /*1232 - 1285*/ 0); // Negative times not currently supported

		// Setup time for E input
		$setup(E, negedge C, 0);

		// Setup time for R input
		$setup(R, negedge C &&& E, 530);

		// Hold time for Q output when E and R are high
		if (E && R) (negedge C => (Q : 1'b0)) = 1391;

		// Hold time for Q output when E is high and R is low
		if (E && !R) (negedge C => (Q : D)) = 1391;
	endspecify
`endif

endmodule