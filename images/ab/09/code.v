module fsm (
  input clk,
  input b,
  input [1:0] q,
  output reg Q0,
  output reg v);always_comb begin
		case ({q[1:0], b})
			3'h0: Q0 = 1;
			3'h1: Q0 = 0;
			3'h2: Q0 = 0;
			3'h3: Q0 = 1;
			3'h4: Q0 = 1;
			3'h5: Q0 = 0;
			3'h6: Q0 = 1;
			3'h7: Q0 = 0;
			default: Q0 = 1'bx;
		endcase
		
		case (q[1:0])
			2'h0: v = 1;
			2'h1: v = 0;
			2'h2: v = 1;
			2'h3: v = 0;
			default: v = 1'bx;
		endcase
	end
	
endmodule