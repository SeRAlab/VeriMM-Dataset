module top_module(
  input a,
  input b,
  input cin,
  output s,
  output cout
);// half adder
// inputs: a, b
// outputs: s, c
// s = a XOR b
// c = a AND b
wire ha_s = a ^ b;
wire ha_c = a & b;

// full adder
// inputs: a, b, cin
// outputs: s, cout
// s = a XOR b XOR cin
// cout = (a AND b) OR (a AND cin) OR (b AND cin)
wire fa_s1 = a ^ b;
wire fa_s = fa_s1 ^ cin;
wire fa_c1 = a & b;
wire fa_c2 = a & cin;
wire fa_c3 = b & cin;
wire fa_cout = fa_c1 | fa_c2 | fa_c3;

assign s = fa_s;
assign cout = fa_cout;

endmodule