module state_fsm (
  input clk,
  input f,
  input [2:0] p,
  output reg P0,
  output reg s);always_comb begin
		case ({p[2:0], f})
			4'h0: P0 = 1;
			4'h1: P0 = 0;
			4'h2: P0 = 0;
			4'h3: P0 = 1;
			4'h4: P0 = 1;
			4'h5: P0 = 0;
			4'h6: P0 = 1;
			4'h7: P0 = 0;
			4'h8: P0 = 0;
			4'h9: P0 = 1;
			default: P0 = 1'bx;
		endcase
		
		case (p[2:0])
			3'h0: s = 1;
			3'h1: s = 1;
			3'h2: s = 0;
			3'h3: s = 0;
			3'h4: s = 1;
			default: s = 1'bx;
		endcase
	end
	
endmodule