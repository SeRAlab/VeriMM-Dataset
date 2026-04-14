module top_module (
	input [4:1] x,
	output reg h);always_comb begin
		case (x) 
			4'h0: h = 0;
			4'h1: h = 1;
			4'h2: h = 0;
			4'h3: h = 1;
			4'h4: h = 0;
			4'h5: h = 1;
			4'h6: h = 1;
			4'h7: h = 0;
			4'h8: h = 1;
			4'h9: h = 0;
			4'ha: h = 1;
			4'hb: h = 0;
			4'hc: h = 1;
			4'hd: h = 0;
			4'he: h = 0;
			4'hf: h = 1;
		endcase
	end

endmodule