module top_module(
  input wire [0 : 0] In0,
  input wire [0 : 0] In1,
  output wire [1 : 0] dout
);// Concatenating In0 and In1
  assign dout = {In1, In0};

endmodule