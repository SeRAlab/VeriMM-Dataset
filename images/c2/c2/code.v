module comparator (
  input [n-1:0] in1,
  input [n-1:0] in2,
  output out
);

parameter n = 4; // number of bits in input signals
parameter s = 0; // 0 for unsigned, 1 for signed

  assign out = (s == 1) ? (in1[n-1] ^ in2[n-1] ? in1[n-1] : in1 > in2) : (in1 > in2);

endmodule