module top_module(
    input [3:0] a,
    input [3:0] b,
    input cin,
    output [3:0] sum,
    output cout
);wire [3:0] sum_temp;
wire c1, c2, c3;

assign sum_temp[0] = a[0] ^ b[0] ^ cin;
assign sum_temp[1] = a[1] ^ b[1] ^ c1;
assign sum_temp[2] = a[2] ^ b[2] ^ c2;
assign sum_temp[3] = a[3] ^ b[3] ^ c3;

assign cout = c3;

assign sum = sum_temp;

assign c1 = (a[0] & b[0]) | (cin & a[0]) | (cin & b[0]);
assign c2 = (a[1] & b[1]) | (c1 & a[1]) | (c1 & b[1]);
assign c3 = (a[2] & b[2]) | (c2 & a[2]) | (c2 & b[2]) | (c1 & c2 & c3);

endmodule