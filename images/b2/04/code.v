module simple_fsm (
  input clk,
  input h,
  input [2:0] e,
  output reg E,
  output reg f);always_comb begin
		case ({e[2:0], h})
			4'h0: E = 1;
			4'h1: E = 0;
			4'h2: E = 0;
			4'h3: E = 1;
			4'h4: E = 1;
			4'h5: E = 0;
			4'h6: E = 1;
			4'h7: E = 0;
			4'h8: E = 0;
			4'h9: E = 1;
			default: E = 1'bx;
		endcase
		
		case (e[2:0])
			3'h0: f = 1;
			3'h1: f = 0;
			3'h2: f = 1;
			3'h3: f = 0;
			3'h4: f = 1;
			default: f = 1'bx;
		endcase
	end
	
endmodule