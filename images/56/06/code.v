module top_module (
	input [3:0] m,
	output reg p);always_comb begin
		case (m)
			4'h0: p = 1;
			4'h1: p = 1;
			4'h2: p = 0;
			4'h3: p = 0;
			4'h4: p = 1;
			4'h5: p = 0;
			4'h6: p = 1;
			4'h7: p = 0;
			4'h8: p = 1;
			4'h9: p = 1;
			4'ha: p = 0;
			4'hb: p = 1;
			4'hc: p = 0;
			4'hd: p = 1;
			4'he: p = 0;
			4'hf: p = 0;
		endcase
	end

endmodule