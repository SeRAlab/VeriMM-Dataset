module ripple_carry_adder (
  input [3:0] a, b,
  input cin,
  output [3:0] sum,
  output cout
);

  wire [3:0] c;
  
  assign c[0] = cin;
  assign c[1] = (a[0] & b[0]) | (a[0] & cin) | (b[0] & cin);
  assign c[2] = (a[1] & b[1]) | (a[1] & c[1]) | (b[1] & c[1]);
  assign c[3] = (a[2] & b[2]) | (a[2] & c[2]) | (b[2] & c[2]);
  
  assign sum = a + b + cin;
  assign cout = c[3];
  
endmodule