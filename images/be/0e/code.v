module top_module( input clk,
	      input 	 d,
	      output reg q);always @(clk,d)
     begin
	if (clk)
	  q <= d;
     end
endmodule