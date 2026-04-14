module top_module(
	output reg Q,
	input C, R, D, S
);always @(negedge C) begin
		if (R == 1'b0) begin
			Q <= 1'b0;
		end else if (S == 1'b1) begin
			Q <= 1'b1;
		end else begin
			Q <= D;
		end
	end

`ifdef ICE40_HX
	specify
		$setup(D, negedge C, 21);
		$setup(R, negedge C, 9);
		$hold(Q, negedge C, 10);
	endspecify
`endif

`ifdef ICE40_LP
	specify
		$setup(D, negedge C, 33);
		$setup(R, negedge C, 15);
		$hold(Q, negedge C, 15);
	endspecify
`endif

`ifdef ICE40_U
	specify
		$setup(D, negedge C, 45);
		$setup(R, negedge C, 21);
		$hold(Q, negedge C, 20);
	endspecify
`endif

endmodule