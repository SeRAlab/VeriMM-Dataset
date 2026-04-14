module top_module(a, b, p);input [19 - 1 : 0] a; 
input [8 - 1 : 0] b; 
output [27 - 1 : 0] p; 

assign p = $unsigned (a) * $unsigned (b);

endmodule