module top_module (
	input [3:0] d,
	output reg v);always_comb begin
		case (d) 
			4'h0: v = 0;
			4'h1: v = 1;
			4'h2: v = 1;
			4'h3: v = 0;
			4'h4: v = 0;
			4'h5: v = 1;
			4'h6: v = 1;
			4'h7: v = 0;
			4'h8: v = 1;
			4'h9: v = 0;
			4'ha: v = 0;
			4'hb: v = 1;
			4'hc: v = 1;
			4'hd: v = 0;
			4'he: v = 0;
			4'hf: v = 1;
		endcase
	end

endmodule