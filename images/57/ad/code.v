module state_machine (
  input clk,
  input a,
  input [1:0] s,
  output reg S0,
  output reg w);always_comb begin
		case ({s[1:0], a})
			3'h0: S0 = 1;
			3'h1: S0 = 0;
			3'h2: S0 = 1;
			3'h3: S0 = 0;
			3'h4: S0 = 0;
			3'h5: S0 = 1;
			3'h6: S0 = 0;
			3'h7: S0 = 1;
			default: S0 = 1'bx;
		endcase
		
		case (s[1:0])
			2'h0: w = 0;
			2'h1: w = 1;
			2'h2: w = 1;
			2'h3: w = 0;
			default: w = 1'bx;
		endcase
	end
	
endmodule