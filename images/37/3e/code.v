module logistic_regression (
    input [4:0] x,  // Input vector
    input [4:0] w,  // Weight vector
    output reg y     // Output class
);
    wire [5:0] weighted_sum; // 6-bit to accommodate possible carry

    // Compute weighted sum
    assign weighted_sum = (x[0] & w[0]) + (x[1] & w[1]) + (x[2] & w[2]) + (x[3] & w[3]) + (x[4] & w[4]);

    // Apply logistic decision threshold
    always @(*) begin
        if (weighted_sum > 16)
            y = 1;
        else
            y = 0;
    end
endmodule