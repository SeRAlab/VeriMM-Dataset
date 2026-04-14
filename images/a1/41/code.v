module top_module(out, in1, in2, carry);output out;
  input in1;
  input in2;
  input carry;

  assign out = in1 ^ in2 ^ carry;endmodule