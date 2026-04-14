module fsm_example3 (
  input clk,
  input g,
  input [2:0] t,
  output reg T1,
  output reg z);always_comb begin
		case ({t[2:0], g})
			4'h0: T1 = 0;
			4'h1: T1 = 1;
			4'h2: T1 = 1;
			4'h3: T1 = 0;
			4'h4: T1 = 0;
			4'h5: T1 = 1;
			4'h6: T1 = 0;
			4'h7: T1 = 1;
			4'h8: T1 = 1;
			4'h9: T1 = 0;
			default: T1 = 1'bx;
		endcase
		
		case (t[2:0])
			3'h0: z = 0;
			3'h1: z = 1;
			3'h2: z = 0;
			3'h3: z = 1;
			3'h4: z = 1;
			default: z = 1'bx;
		endcase
	end
	
endmodule