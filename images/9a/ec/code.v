module top_module(s, a);output s;
 input  a;
 
 assign s = ~(a & a);endmodule