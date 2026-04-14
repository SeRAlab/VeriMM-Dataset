module logistic_regression(
    input [3:0] X,
    input [3:0] W,
    output reg Y
);
    wire signed [7:0] dot_product;
    wire [7:0] sigmoid_input;

    assign dot_product = (X[0] * W[0]) + (X[1] * W[1]) + (X[2] * W[2]) + (X[3] * W[3]);
    assign sigmoid_input = dot_product + 4; // offset to handle negative values for sigmoid approximation

    always @(*) begin
        if (sigmoid_input >= 8) // 0.5 threshold in 8-bit representation
            Y = 1;
        else
            Y = 0;
    end
endmodule