module top_module(O, in0, in1, cbit, prog);output O;
  input cbit;
  input in0;
  input in1;
  input prog;

  wire sel;
  assign sel = (prog & ~cbit) | (~prog & cbit);

  assign O = sel ? in0 : in1;
endmodule