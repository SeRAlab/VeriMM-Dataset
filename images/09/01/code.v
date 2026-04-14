module perceptron (
    input wire [1:0] x,   // 2-bit input
    output wire y         // 1-bit output
);
    parameter W0 = 2'b01;  // Weight for input x0
    parameter W1 = 2'b01;  // Weight for input x1
    parameter THRESHOLD = 1; // Threshold for activation

    wire [1:0] weighted_sum;

    assign weighted_sum = (x[0] * W0) + (x[1] * W1);
    assign y = (weighted_sum > THRESHOLD) ? 1'b1 : 1'b0;

endmodule