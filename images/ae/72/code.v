module top_module(input clk, rst, s, r, 
				  output reg srOut);always @(posedge clk, posedge rst)
		if(rst) srOut <= 1'b0; else
		if(s)	  srOut <= 1'b1; else
		if(r)   srOut <= 1'b0; 
		else	  srOut <= srOut;


endmodule