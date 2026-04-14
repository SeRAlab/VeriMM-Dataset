module simple_fsm (
  input clk,
  input k,
  input [2:0] i,
  output reg I,
  output reg j);always_comb begin
		case ({i[2:0], k})
			4'h0: I = 1;
			4'h1: I = 0;
			4'h2: I = 0;
			4'h3: I = 1;
			4'h4: I = 1;
			4'h5: I = 0;
			4'h6: I = 1;
			4'h7: I = 0;
			4'h8: I = 0;
			4'h9: I = 1;
			default: I = 1'bx;
		endcase
		
		case (i[2:0])
			3'h0: j = 1;
			3'h1: j = 0;
			3'h2: j = 1;
			3'h3: j = 0;
			3'h4: j = 1;
			default: j = 1'bx;
		endcase
	end
	
endmodule