module top_module(/*AUTOARG*/
   // Outputs
   z,
   // Inputs
   a0, a1, s
   );input a0;
  input a1;
  input s;
  output z;

  assign z = s ? a1 : a0;

endmodule