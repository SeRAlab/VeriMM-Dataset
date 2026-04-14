module top_module (
	input [3:0] w,
	output reg k);always_comb begin
		case (w)
			4'h0: k = 1;
			4'h1: k = 0;
			4'h2: k = 0;
			4'h3: k = 1;
			4'h4: k = 0;
			4'h5: k = 1;
			4'h6: k = 1;
			4'h7: k = 0;
			4'h8: k = 0;
			4'h9: k = 1;
			4'ha: k = 0;
			4'hb: k = 1;
			4'hc: k = 1;
			4'hd: k = 0;
			4'he: k = 0;
			4'hf: k = 1;
		endcase
	end

endmodule