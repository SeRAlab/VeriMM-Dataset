module top_module(a, b, p);input [16 - 1 : 0] a; 
input [16 - 1 : 0] b; 
output [32 - 1 : 0] p; 

assign p = $unsigned (a) * $unsigned (b);

endmodule