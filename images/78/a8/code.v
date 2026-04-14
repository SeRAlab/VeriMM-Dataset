module top_module (
	input [3:0] b,
	output reg z);always_comb begin
		case (b) 
			4'h0: z = 1;
			4'h1: z = 0;
			4'h2: z = 1;
			4'h3: z = 0;
			4'h4: z = 1;
			4'h5: z = 0;
			4'h6: z = 1;
			4'h7: z = 0;
			4'h8: z = 0;
			4'h9: z = 1;
			4'ha: z = 0;
			4'hb: z = 1;
			4'hc: z = 0;
			4'hd: z = 1;
			4'he: z = 0;
			4'hf: z = 1;
		endcase
	end

endmodule