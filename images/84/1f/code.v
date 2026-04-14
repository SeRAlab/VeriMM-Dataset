module fsm_example4 (
  input clk,
  input h,
  input [2:0] u,
  output reg U0,
  output reg x);always_comb begin
		case ({u[2:0], h})
			4'h0: U0 = 1;
			4'h1: U0 = 0;
			4'h2: U0 = 0;
			4'h3: U0 = 1;
			4'h4: U0 = 1;
			4'h5: U0 = 0;
			4'h6: U0 = 1;
			4'h7: U0 = 0;
			4'h8: U0 = 0;
			4'h9: U0 = 1;
			default: U0 = 1'bx;
		endcase
		
		case (u[2:0])
			3'h0: x = 0;
			3'h1: x = 1;
			3'h2: x = 1;
			3'h3: x = 0;
			3'h4: x = 1;
			default: x = 1'bx;
		endcase
	end
	
endmodule