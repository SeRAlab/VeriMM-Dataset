module top_module (
	input [3:0] a,
	output reg y);always_comb begin
		case (a) 
			4'h0: y = 0;
			4'h1: y = 1;
			4'h2: y = 0;
			4'h3: y = 1;
			4'h4: y = 0;
			4'h5: y = 1;
			4'h6: y = 0;
			4'h7: y = 1;
			4'h8: y = 1;
			4'h9: y = 0;
			4'ha: y = 1;
			4'hb: y = 0;
			4'hc: y = 1;
			4'hd: y = 0;
			4'he: y = 1;
			4'hf: y = 0;
		endcase
	end

endmodule