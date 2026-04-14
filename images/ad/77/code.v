module top_state (
  input clk,
  input e,
  input [1:0] r,
  output reg R0,
  output reg t);always_comb begin
		case ({r[1:0], e})
			3'h0: R0 = 1;
			3'h1: R0 = 0;
			3'h2: R0 = 0;
			3'h3: R0 = 1;
			3'h4: R0 = 1;
			3'h5: R0 = 0;
			3'h6: R0 = 1;
			3'h7: R0 = 0;
			default: R0 = 1'bx;
		endcase
		
		case (r[1:0])
			2'h0: t = 1;
			2'h1: t = 1;
			2'h2: t = 0;
			2'h3: t = 0;
			default: t = 1'bx;
		endcase
	end
	
endmodule