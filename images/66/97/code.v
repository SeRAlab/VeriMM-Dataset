module top_module(
    input x, 
    input y, 
    input s, 
    output m 
  );assign m = s & y | ~s & x;endmodule