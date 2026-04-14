module top_module (
	input [4:1] x,
	output reg g);always_comb begin
		case (x) 
			4'h0: g = 0;
			4'h1: g = 0;
			4'h2: g = 1;
			4'h3: g = 1;
			4'h4: g = 0;
			4'h5: g = 0;
			4'h6: g = 0;
			4'h7: g = 1;
			4'h8: g = 1;
			4'h9: g = 1;
			4'ha: g = 1;
			4'hb: g = 1;
			4'hc: g = 0;
			4'hd: g = 1;
			4'he: g = 0;
			4'hf: g = 0;
		endcase
	end

endmodule