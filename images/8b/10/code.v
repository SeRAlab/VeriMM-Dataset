module adder_4bit (
    input [3:0] a,
    input [3:0] b,
    output [3:0] sum
);

    // Adder logic
    assign sum = a + b;

endmodule