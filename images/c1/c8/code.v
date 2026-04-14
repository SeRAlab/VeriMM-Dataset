module mul_mux2 ( z, d0, d1, s );
output  z;
input  d0, d1, s;
assign z = s ? d1 : d0 ;
endmodule