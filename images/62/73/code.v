module fsm_example2 (
  input clk,
  input f,
  input [2:0] v,
  output reg V1,
  output reg y);always_comb begin
		case ({v[2:0], f})
			4'h0: V1 = 0;
			4'h1: V1 = 1;
			4'h2: V1 = 1;
			4'h3: V1 = 0;
			4'h4: V1 = 0;
			4'h5: V1 = 1;
			4'h6: V1 = 0;
			4'h7: V1 = 1;
			4'h8: V1 = 1;
			4'h9: V1 = 0;
			default: V1 = 1'bx;
		endcase
		
		case (v[2:0])
			3'h0: y = 1;
			3'h1: y = 1;
			3'h2: y = 0;
			3'h3: y = 0;
			3'h4: y = 1;
			default: y = 1'bx;
		endcase
	end
	
endmodule