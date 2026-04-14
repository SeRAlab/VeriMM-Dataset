module top_module(
   
   z,
   
   a, b
   );parameter DELAY = 1;
  input a,b;
  output z;

  assign #DELAY z= a & b;

endmodule