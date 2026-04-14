module mul_csa42 (sum, carry, cout, a, b, c, d, cin);
output sum, carry, cout;
input a, b, c, d, cin;
wire x, y, z;
assign x = a ^ b;
assign y = c ^ d;
assign z = x ^ y;
assign sum = z ^ cin ;
assign carry = (b & ~z) | (cin & z);
assign cout = (d & ~y) | (a & y);
endmodule