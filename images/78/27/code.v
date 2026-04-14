module top_module(
    input a, b, cin,
    output cout, sum
);wire x1, x2, x3, x4, x5, x6, x7, x8;

assign x1 = a & b;
assign x2 = a ^ b;
assign x3 = x2 & cin;
assign x4 = x1 | x3;
assign x5 = a & cin;
assign x6 = b & cin;
assign x7 = x5 | x6;
assign x8 = x2 ^ cin;

assign sum = x4 ^ cin;
assign cout = x7 | x8;

endmodule