module top_module (
	input [3:0] s,
	output reg r);always_comb begin
		case (s)
			4'h0: r = 0;
			4'h1: r = 1;
			4'h2: r = 0;
			4'h3: r = 1;
			4'h4: r = 0;
			4'h5: r = 1;
			4'h6: r = 0;
			4'h7: r = 1;
			4'h8: r = 0;
			4'h9: r = 1;
			4'ha: r = 0;
			4'hb: r = 1;
			4'hc: r = 0;
			4'hd: r = 1;
			4'he: r = 0;
			4'hf: r = 1;
		endcase
	end

endmodule