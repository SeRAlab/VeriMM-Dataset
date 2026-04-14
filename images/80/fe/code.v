module even_parity_gen (
  input [5:0] d,
  output parity);assign parity = ^d;
endmodule