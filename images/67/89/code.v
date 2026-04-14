module simple_fsm (
  input clk,
  input f,
  input [2:0] a,
  output reg A,
  output reg b);always_comb begin
		case ({a[2:0], f})
			4'h0: A = 1;
			4'h1: A = 0;
			4'h2: A = 0;
			4'h3: A = 1;
			4'h4: A = 1;
			4'h5: A = 0;
			4'h6: A = 1;
			4'h7: A = 0;
			4'h8: A = 0;
			4'h9: A = 1;
			default: A = 1'bx;
		endcase
		
		case (a[2:0])
			3'h0: b = 1;
			3'h1: b = 0;
			3'h2: b = 1;
			3'h3: b = 0;
			3'h4: b = 1;
			default: b = 1'bx;
		endcase
	end
	
endmodule