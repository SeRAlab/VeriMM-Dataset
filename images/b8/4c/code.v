module top_module (
	input [3:0] w,
	output reg t);always_comb begin
		case (w)
			4'h0: t = 1;
			4'h1: t = 0;
			4'h2: t = 1;
			4'h3: t = 0;
			4'h4: t = 1;
			4'h5: t = 0;
			4'h6: t = 0;
			4'h7: t = 1;
			4'h8: t = 0;
			4'h9: t = 1;
			4'ha: t = 0;
			4'hb: t = 1;
			4'hc: t = 0;
			4'hd: t = 0;
			4'he: t = 1;
			4'hf: t = 0;
		endcase
	end

endmodule