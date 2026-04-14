module top_module (
	input [4:1] x,
	output reg j);always_comb begin
		case (x) 
			4'h0: j = 1;
			4'h1: j = 1;
			4'h2: j = 0;
			4'h3: j = 1;
			4'h4: j = 1;
			4'h5: j = 0;
			4'h6: j = 0;
			4'h7: j = 1;
			4'h8: j = 1;
			4'h9: j = 0;
			4'ha: j = 0;
			4'hb: j = 0;
			4'hc: j = 0;
			4'hd: j = 0;
			4'he: j = 1;
			4'hf: j = 1;
		endcase
	end

endmodule