module HalfAdder (
  input a,
  input b,
  output s,
  output c
);
  assign s = a ^ b;
  assign c = a & b;
endmodule

module FullAdder (
  input a,
  input b,
  input cin,
  output s,
  output cout
);
  wire c1;
  wire s1;
  HalfAdder HA1(.a(a), .b(b), .s(s1), .c(c1));
  HalfAdder HA2(.a(s1), .b(cin), .s(s), .c(cout));
  assign cout = c1 | cout;
endmodule