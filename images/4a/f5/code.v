module top_module(a, b, cin, sum, ca);input [63:0]a, b, cin;
output [63:0]sum, ca;

assign sum = a ^ b ^ cin;
assign ca[0]=0;
assign ca[63:1] = (a & b) | (a & cin) | (b & cin);

endmodule