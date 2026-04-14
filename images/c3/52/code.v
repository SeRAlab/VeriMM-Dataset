module BrzSlice_1_18_16 (
  out_0r, out_0a, out_0d,
  inp_0r, inp_0a, inp_0d
);
  input out_0r;
  output out_0a;
  output out_0d;
  output inp_0r;
  input inp_0a;
  input [17:0] inp_0d;
  assign inp_0r = out_0r;
  assign out_0a = inp_0a;
  assign out_0d = inp_0d[16];
endmodule