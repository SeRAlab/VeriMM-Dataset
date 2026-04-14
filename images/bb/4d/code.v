module top_module (
    input [7:0] a,
    input [7:0] b,
    input cin,
    output [7:0] sum,
    output cout
);

    assign {cout, sum} = a + b + cin; // 8-bit addition with carry-in and carry-out

endmodule