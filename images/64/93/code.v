module parity_generator(
  input [2:0] data,
  output parity
);

  assign parity = ~(data[2] ^ data[1] ^ data[0]);

endmodule