module logistic_regression (
    input [3:0] x0,
    input [3:0] x1,
    input [3:0] x2,
    input [3:0] x3,
    output reg y
);
    // Define weights
    parameter [3:0] w0 = 4'b0001; // Weight for x0
    parameter [3:0] w1 = 4'b0010; // Weight for x1
    parameter [3:0] w2 = 4'b0011; // Weight for x2
    parameter [3:0] w3 = 4'b0100; // Weight for x3

    wire [7:0] weighted_sum;

    // Compute weighted sum
    assign weighted_sum = (w0 * x0) + (w1 * x1) + (w2 * x2) + (w3 * x3);

    // Sigmoid function approximation
    always @* begin
        if (weighted_sum > 8'd128) // Threshold for sigmoid output
            y = 1'b1;
        else
            y = 1'b0;
    end
endmodule