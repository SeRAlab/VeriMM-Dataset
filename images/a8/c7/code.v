module top_module (
	input [2:0] w,
	output reg m);always_comb begin
		case (w)
			3'h0: m = 1;
			3'h1: m = 1;
			3'h2: m = 0;
			3'h3: m = 0;
			3'h4: m = 1;
			3'h5: m = 1;
			3'h6: m = 0;
			3'h7: m = 0;
		endcase
	end

endmodule