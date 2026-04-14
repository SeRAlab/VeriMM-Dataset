module top_module(
    input ctrl,
    input D0,
    input D1,
    output S
);wire sel;
  assign sel = ctrl;

  // Use a standard conditional operator for a 2-to-1 multiplexer
  assign S = sel ? D1 : D0;

endmodule