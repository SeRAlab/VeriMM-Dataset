module top_module(input d, clk, set, output reg q);always @(posedge clk or posedge set)
    if(set)
	    q <= 1;
	else
	    q <= d;
endmodule