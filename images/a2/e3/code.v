module top_module(
    input [7:0] in1,
    input [7:0] in2,
    output reg [7:0] sum
    );// The sum of two 8-bit unsigned integers can be calculated by simply adding them together.
    // We can use the "+" operator to perform the addition.
    // Since we are using unsigned integers, the output will automatically wrap around if it exceeds 8 bits.

    assign sum = in1 + in2;

endmodule