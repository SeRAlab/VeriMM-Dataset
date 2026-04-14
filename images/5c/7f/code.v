module top_module( j , k );output j;
input  k;

assign j = ~( k & k  );endmodule