module top_module(out_Q, in_D, Ld, clk, clr);output reg[31:0] out_Q;
			 input [31:0] in_D;
			 input Ld;
			 input clk, clr;
			 always @(posedge clk)
			 	if(clr)
					out_Q <= 32'd0;
				else if (Ld)
					out_Q <= in_D;endmodule