module top_module (
	input [3:0] c,
	output reg w);always_comb begin
		case (c) 
			4'h0: w = 1;
			4'h1: w = 1;
			4'h2: w = 0;
			4'h3: w = 1;
			4'h4: w = 0;
			4'h5: w = 0;
			4'h6: w = 1;
			4'h7: w = 0;
			4'h8: w = 1;
			4'h9: w = 0;
			4'ha: w = 1;
			4'hb: w = 0;
			4'hc: w = 1;
			4'hd: w = 1;
			4'he: w = 0;
			4'hf: w = 1;
		endcase
	end

endmodule