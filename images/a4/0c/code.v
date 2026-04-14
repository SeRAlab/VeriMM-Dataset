module top_module(
    input a,
    input b,
    input cin,
    output sum,
    output cout
);

    assign {cout, sum} = a + b + cin;  // 1-bit full adder

endmodule