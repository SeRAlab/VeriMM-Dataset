module fsm_example5 (
  input clk,
  input i,
  input [2:0] s,
  output reg S1,
  output reg y);always_comb begin
		case ({s[2:0], i})
			4'h0: S1 = 1;
			4'h1: S1 = 0;
			4'h2: S1 = 0;
			4'h3: S1 = 1;
			4'h4: S1 = 1;
			4'h5: S1 = 0;
			4'h6: S1 = 1;
			4'h7: S1 = 0;
			4'h8: S1 = 0;
			4'h9: S1 = 1;
			default: S1 = 1'bx;
		endcase
		
		case (s[2:0])
			3'h0: y = 1;
			3'h1: y = 1;
			3'h2: y = 0;
			3'h3: y = 1;
			3'h4: y = 0;
			default: y = 1'bx;
		endcase
	end
	
endmodule