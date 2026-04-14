module top_module(
  input [3:0] binary,
  output [1:0] gray
);assign gray[0] = binary[0] ^ binary[1];
  assign gray[1] = binary[1] ^ binary[2];

endmodule