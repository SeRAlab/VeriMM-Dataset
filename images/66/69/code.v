module parity_generator (
  input [2:0] a,
  output parity);

assign parity = a[0] ^ a[1] ^ a[2];
endmodule