module logistic_regression (
    input wire x1,
    input wire x2,
    output wire y
);
    wire [1:0] weighted_sum;
    
    // Linear combination: y = w1*x1 + w2*x2
    assign weighted_sum = {1'b0, x1} + {1'b0, x2}; // w1 = w2 = 1 for simplicity

    // Logistic function approximation: threshold at 1
    assign y = (weighted_sum > 2'b01) ? 1'b1 : 1'b0; // Activation function

endmodule