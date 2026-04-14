module top_module (
    input [7:0] a,
    input [7:0] b,
    input cin,
    output [7:0] y,
    output cout
);

    // Perform addition with carry-in
    assign {cout, y} = a + b + cin;

endmodule