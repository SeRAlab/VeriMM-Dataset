module top_module(
    input [3:0] a,
    input [3:0] b,
    input cin,
    output [3:0] sum,
    output cout
);wire [3:0] carry;
assign carry[0] = cin;
assign carry[1] = a[0] & b[0] | a[0] & cin | b[0] & cin;
assign carry[2] = a[1] & b[1] | a[1] & carry[1] | b[1] & carry[1];
assign carry[3] = a[2] & b[2] | a[2] & carry[2] | b[2] & carry[2];

assign sum[0] = a[0] ^ b[0] ^ cin;
assign sum[1] = a[1] ^ b[1] ^ carry[1];
assign sum[2] = a[2] ^ b[2] ^ carry[2];
assign sum[3] = a[3] ^ b[3] ^ carry[3];

assign cout = carry[3];

endmodule