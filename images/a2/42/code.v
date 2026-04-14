module top_module (
	input [2:0] t,
	output reg q);always_comb begin
		case (t)
			3'h0: q = 1;
			3'h1: q = 0;
			3'h2: q = 1;
			3'h3: q = 0;
			3'h4: q = 1;
			3'h5: q = 0;
			3'h6: q = 1;
			3'h7: q = 0;
		endcase
	end

endmodule