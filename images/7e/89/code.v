module binary_adder (
    input [3:0] a,
    input [3:0] b,
    output [3:0] sum
);

    // Adder logic
    assign sum = a + b;

endmodule