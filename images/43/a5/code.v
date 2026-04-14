module top_module(
  input [3:0] in_binary,
  input [3:0] in_gray,
  output [3:0] out_binary,
  output [3:0] out_gray
);assign out_binary[0] = in_gray[0] ^ in_binary[1];
  assign out_binary[1] = in_gray[1] ^ in_binary[2];
  assign out_binary[2] = in_gray[2] ^ in_binary[3];
  assign out_binary[3] = in_gray[3] ^ in_binary[0];

  assign out_gray[0] = in_binary[0] ^ in_binary[1];
  assign out_gray[1] = in_binary[1] ^ in_binary[2];
  assign out_gray[2] = in_binary[2] ^ in_binary[3];
  assign out_gray[3] = in_binary[3] ^ in_binary[0];

endmodule