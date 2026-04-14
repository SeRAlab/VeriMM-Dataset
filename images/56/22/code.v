module simple_fsm (
  input clk,
  input g,
  input [2:0] c,
  output reg C,
  output reg d);always_comb begin
		case ({c[2:0], g})
			4'h0: C = 1;
			4'h1: C = 0;
			4'h2: C = 0;
			4'h3: C = 1;
			4'h4: C = 1;
			4'h5: C = 0;
			4'h6: C = 1;
			4'h7: C = 0;
			4'h8: C = 0;
			4'h9: C = 1;
			default: C = 1'bx;
		endcase
		
		case (c[2:0])
			3'h0: d = 0;
			3'h1: d = 1;
			3'h2: d = 0;
			3'h3: d = 1;
			3'h4: d = 0;
			default: d = 1'bx;
		endcase
	end
	
endmodule