module mux_1bit(
  input ctrl,
  input D0,
  input D1,
  output S
);

  assign S = ctrl ? D1 : D0;

endmodule