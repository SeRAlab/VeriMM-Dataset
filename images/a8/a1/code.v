module top_module(d,l,q);input [1:32] d,l; 
 output [1:32] q; 
 assign q = d ^ l; 
 endmodule