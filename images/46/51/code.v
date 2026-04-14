module top_module(
  output Q,
  input A
);assign Q = A ? 0 : 1;
endmodule