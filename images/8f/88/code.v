module top_module(input wire clk, reset, d, carga, output reg q);always @(posedge clk, posedge reset)
    if (reset)
	    q <= 1'b0;
	  else
	    if (carga)
	      q <= d;endmodule