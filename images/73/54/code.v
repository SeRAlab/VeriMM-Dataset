module top_module (
	input [3:0] v,
	output reg u);always_comb begin
		case (v)
			4'h0: u = 0;
			4'h1: u = 1;
			4'h2: u = 0;
			4'h3: u = 0;
			4'h4: u = 1;
			4'h5: u = 1;
			4'h6: u = 0;
			4'h7: u = 1;
			4'h8: u = 0;
			4'h9: u = 1;
			4'ha: u = 0;
			4'hb: u = 0;
			4'hc: u = 1;
			4'hd: u = 1;
			4'he: u = 0;
			4'hf: u = 0;
		endcase
	end

endmodule