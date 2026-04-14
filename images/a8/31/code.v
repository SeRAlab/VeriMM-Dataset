module simple_fsm (
  input clk,
  input d,
  input [2:0] w,
  output reg W0,
  output reg x);always_comb begin
		case ({w[2:0], d})
			4'h0: W0 = 1;
			4'h1: W0 = 0;
			4'h2: W0 = 0;
			4'h3: W0 = 1;
			4'h4: W0 = 1;
			4'h5: W0 = 0;
			4'h6: W0 = 1;
			4'h7: W0 = 0;
			4'h8: W0 = 0;
			4'h9: W0 = 1;
			default: W0 = 1'bx;
		endcase
		
		case (w[2:0])
			3'h0: x = 0;
			3'h1: x = 1;
			3'h2: x = 0;
			3'h3: x = 1;
			3'h4: x = 0;
			default: x = 1'bx;
		endcase
	end
	
endmodule