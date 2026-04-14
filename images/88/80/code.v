module top_module(I, O);input [11:0] I;
  output O;

  wire [11:0] or_result;
  assign or_result = |I;

  assign O = |or_result;

endmodule