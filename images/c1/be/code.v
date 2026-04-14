module mul_negen ( n0, n1, b );
output  n0, n1;
input [2:0]  b;
assign n0 = b[2] & b[1] & ~b[0] ;
assign n1 = b[2] & b[1] & b[0] ;
endmodule