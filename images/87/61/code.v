module top_module(
    A,
    B,
    Sum,
    Difference,
    Product
);input [3:0] A;
    input [3:0] B;
    output [4:0] Sum;
    output signed [4:0] Difference;
    output [7:0] Product;

    wire [3:0] A_N;
    wire [3:0] B_N;

    // Simple NOT gate implementation to negate inputs
    assign A_N = ~A;
    assign B_N = ~B;

    assign Sum = A + B;
    assign Difference = $signed(A) - $signed(B);
    assign Product = A * B;

endmodule