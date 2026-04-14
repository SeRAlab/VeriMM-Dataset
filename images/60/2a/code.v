module top_module (
	input [2:0] v,
	output reg n);always_comb begin
		case (v)
			3'h0: n = 0;
			3'h1: n = 1;
			3'h2: n = 1;
			3'h3: n = 0;
			3'h4: n = 1;
			3'h5: n = 0;
			3'h6: n = 0;
			3'h7: n = 1;
		endcase
	end

endmodule