module top_module (
	input [3:0] z,
	output reg l);always_comb begin
		case (z)
			4'h0: l = 1;
			4'h1: l = 0;
			4'h2: l = 1;
			4'h3: l = 0;
			4'h4: l = 1;
			4'h5: l = 1;
			4'h6: l = 0;
			4'h7: l = 1;
			4'h8: l = 0;
			4'h9: l = 1;
			4'ha: l = 0;
			4'hb: l = 1;
			4'hc: l = 1;
			4'hd: l = 0;
			4'he: l = 1;
			4'hf: l = 0;
		endcase
	end

endmodule