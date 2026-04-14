module top_module(
    count,
    sum,
    a,
    b,
    cin
);input [2:0] a, b;
    input cin;
    output count;
    output [2:0] sum;
    assign {count, sum} = a + b + cin;endmodule