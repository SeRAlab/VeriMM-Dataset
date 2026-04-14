module top_module(yOR,yAND,yXOR,yNOR,yNAND,yXNOR,a,b);output yOR,yAND,yXOR,yNOR,yNAND,yXNOR;
  input a,b;
  
  assign yOR = a | b;
  assign yAND = a & b;
  assign yXOR = a ^ b;
  assign yNOR = ~(a | b);
  assign yNAND = ~(a & b);
  assign yXNOR = ~(a ^ b);
  
endmodule