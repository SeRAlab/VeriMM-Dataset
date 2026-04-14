module comb_circuit (
  input a, b,
  output out1, out2
);

  assign out1 = a ? ~b : b;
  assign out2 = a ? b : ~b;

endmodule