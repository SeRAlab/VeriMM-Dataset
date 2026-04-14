module mul_ha ( cout, sum, a, b );
output  cout, sum;
input  a, b;
assign sum = a ^ b;
assign cout = a & b ;
endmodule