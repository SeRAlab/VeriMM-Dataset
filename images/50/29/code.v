module top_module(a, b, ci, sum, co);input a, b, ci; 
  output sum, co; 
  assign {co,sum} = a + b + ci; 
 endmodule