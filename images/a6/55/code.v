module top_module(
    input [3:0] a,
    input [3:0] b,
    input cin,
    output [3:0] sum,
    output cout
);wire [3:0] c;
assign c[0] = cin;
assign {cout, sum} = a + b + c;

endmodule