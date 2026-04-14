module top_module(q,a,b );input a,b; 
 output [1:0] q; 
 assign q = {1'b0,a} * {1'b0,b}; 
 endmodule