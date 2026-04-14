module top_module(i_0r, i_0a, o_0r, o_0a, reset);input i_0r;
  output i_0a;
  output o_0r;
  input o_0a;
  input reset;
  
  wire b_0;
  wire tech1_oint;
  wire and_out;
  wire nand_out;
  wire inv_out;

  // Using basic gates instead of unknown modules
  assign and_out = (i_0r & b_0) | (tech1_oint & i_0r) | (tech1_oint & b_0);
  assign nand_out = ~(o_0r & reset);
  assign inv_out = ~b_0;
  assign i_0a = o_0r;  // Buffer equivalent is just a direct assignment
  assign o_0a = inv_out;

endmodule