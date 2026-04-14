module dff_with_reset_set (
  input D,
  input RESET_B,
  input SET,
  input CLK,
  output reg Q
);

  always @(posedge CLK or negedge RESET_B)
    if (!RESET_B)
      Q <= 1'b0;
    else if (SET)
      Q <= 1'b1;
    else
      Q <= D;

endmodule