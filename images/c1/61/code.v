module mul_csa32 (sum, cout, a, b, c);
output sum, cout;
input a, b, c;
wire x, y0, y1, y2;
assign x = a ^ b;
assign sum = c ^ x;
assign y0 = a & b ;
assign y1 = a & c ;
assign y2 = b & c ;
assign cout = y0 | y1 | y2 ;
endmodule