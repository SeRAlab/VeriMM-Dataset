module top_module(
   
   z,
   
   a0, a1, s
   );input a0;
  input a1;
  input s;
  output z;

  parameter DELAY = 1;

  assign #DELAY z = s ? a1 : a0;

  

  

  

  


endmodule