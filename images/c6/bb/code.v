module mux_2to1_enable (
  input a,
  input b,
  input en,
  output y
);

  assign y = en ? b : a;

endmodule