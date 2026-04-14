module simple_fsm (
  input clk,
  input e,
  input [2:0] y,
  output reg Y,
  output reg z);always_comb begin
		case ({y[2:0], e})
			4'h0: Y = 1;
			4'h1: Y = 0;
			4'h2: Y = 0;
			4'h3: Y = 1;
			4'h4: Y = 1;
			4'h5: Y = 0;
			4'h6: Y = 1;
			4'h7: Y = 0;
			4'h8: Y = 0;
			4'h9: Y = 1;
			default: Y = 1'bx;
		endcase
		
		case (y[2:0])
			3'h0: z = 1;
			3'h1: z = 0;
			3'h2: z = 1;
			3'h3: z = 0;
			3'h4: z = 1;
			default: z = 1'bx;
		endcase
	end
	
endmodule