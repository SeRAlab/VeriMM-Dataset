module ctu_nor2 (z, a, b);

output z;
input  a;
input  b;

assign z = ~(a | b);

endmodule