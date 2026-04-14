module top_module(
  input in0,
  input in1,
  input sel,
  output out
);assign out = sel ? in1 : in0; // Selects in0 or in1 based on sel
endmodule