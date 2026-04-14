module top_module(
    input a,
    input b,
    input cin,
    output reg sum,
    output reg cout
);wire t1, t2, t3, t4, t5, t6;

assign t1 = a & b;
assign t2 = a ^ b;
assign t3 = t2 & cin;
assign t4 = t1 | t3;
assign t5 = a & cin;
assign t6 = b & cin;

assign sum = t2 ^ cin;
assign cout = t6 | t5 | t3;

endmodule