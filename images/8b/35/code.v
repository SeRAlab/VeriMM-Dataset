module comparator_2bit (
  input [1:0] a,
  input [1:0] b,
  output eq);assign eq = (a == b);

endmodule