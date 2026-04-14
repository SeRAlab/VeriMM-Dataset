module logistic_regression (
    input wire x1,
    input wire x2,
    input wire x3,
    output wire y
);
    wire [3:0] sum;
    wire sigmoid_out;

    assign sum = x1 + x2 + x3 - 1; // w1=1, w2=1, w3=1, b=-1

    // Sigmoid function approximation
    assign sigmoid_out = (sum > 0) ? 1 : 0; // Simple threshold for binary output

    assign y = sigmoid_out;

endmodule