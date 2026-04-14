module top_module(a, b, d);input wire [1:0] a;
input wire [1:0] b;
output wire [2:0] d;

wire [0:0] m1;
wire [0:0] m2;
wire [0:0] m3;
wire [0:0] ahl;
wire [0:0] bhl;
assign m2 = a[0] & b[0];
assign m1 = a[1] & b[1];

assign ahl[0:0] = a[1:1] ^ a[0:0];
assign bhl[0:0] = b[1:1] ^ b[0:0];

assign m3 = ahl & bhl;

assign  d[00] = m2[00];
assign  d[01] = m1[00] ^ m2[00] ^ m3[00];
assign  d[02] = m1[00];
endmodule