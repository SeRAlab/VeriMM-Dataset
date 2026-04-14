module top_module(
  input [0:0] In0,
  input [0:0] In1,
  output [1:0] dout
);assign dout = {In1, In0};

endmodule