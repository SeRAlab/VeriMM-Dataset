module top_module(
  input wire A, B, CI, VPWR, VGND,
  output wire SUM, COUT
);assign SUM = A ^ B ^ CI;
  assign COUT = (A & B) | (CI & (A ^ B));

endmodule