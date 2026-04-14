module top_module(
  input [3:0] bcd,
  output [3:0] bin
);assign bin = bcd[3]*8 + bcd[2]*4 + bcd[1]*2 + bcd[0];

endmodule