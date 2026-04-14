module logistic_regression (
    input wire [2:0] x, // 3 binary inputs
    output reg y        // 1 binary output after sigmoid
);
    // Weights
    parameter W0 = 2'b10; // weight for x[0]
    parameter W1 = 2'b01; // weight for x[1]
    parameter W2 = 2'b11; // weight for x[2]

    wire [4:0] weighted_sum;

    // Calculate weighted sum
    assign weighted_sum = (x[0] * W0) + (x[1] * W1) + (x[2] * W2);

    // Sigmoid function approximation
    always @(*) begin
        if (weighted_sum > 5)
            y = 1'b1; // Output 1 if weighted sum > threshold
        else
            y = 1'b0; // Output 0 otherwise
    end
endmodule