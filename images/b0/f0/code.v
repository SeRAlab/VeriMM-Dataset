module top_module(input [1:0] a, output o, output p);assign o = ^a; 
 assign p = ~o; 
 endmodule