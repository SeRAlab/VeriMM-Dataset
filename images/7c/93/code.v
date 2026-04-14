module top_module(
    input [31:0] PC_in,
    output [31:0] PC_out
  );assign PC_out = PC_in + 4;endmodule