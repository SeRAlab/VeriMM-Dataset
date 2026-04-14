module top_module(sum, c_out, a, b, c_in);input [3:0] a, b;
input c_in;
output [3:0] sum;
output c_out;


wire g0, p0, g1, p1, g2, p2;
wire c1, c2, c3;


assign g0 = a[0] & b[0];
assign p0 = a[0] ^ b[0];
assign c1 = g0 | (p0 & c_in);

assign g1 = a[1] & b[1];
assign p1 = a[1] ^ b[1];
assign c2 = g1 | (p1 & c1);

assign g2 = a[2] & b[2];
assign p2 = a[2] ^ b[2];
assign c3 = g2 | (p2 & c2);

assign g3 = a[3] & b[3];
assign p3 = a[3] ^ b[3];
assign c_out = g3 | (p3 & c3);
 

assign sum[0] = a[0] ^ b[0] ^ c_in;
assign sum[1] = a[1] ^ b[1] ^ c1;
assign sum[2] = a[2] ^ b[2] ^ c2;
assign sum[3] = a[3] ^ b[3] ^ c3;


endmodule