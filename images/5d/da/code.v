module top_module(
    	input [2:0] a,
    	output [1:0] m
    );assign m = a[2] + a[1] + a[0];
 
endmodule