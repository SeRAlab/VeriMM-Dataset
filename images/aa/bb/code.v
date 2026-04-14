module top_module(a,b,z);input[7:0] a,b;
output[7:0] z;

assign z = a&b;

endmodule