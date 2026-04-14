module top_module(
	input T, clk, rst,
	output reg Q
);always @ (posedge clk, negedge rst)
		if (!rst) Q <= 0;
		else case (T)
			1'b0 : Q <= Q;
			1'b1 : Q <= !Q;
		endcase

endmodule