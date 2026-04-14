module logistic_regression (
    input [3:0] x, // 4-bit input representing x1, x2, x3, x4
    output reg y
);
    // Parameters for weights and bias
    parameter w1 = 4'b0001; // 1
    parameter w2 = 4'b0010; // 2
    parameter w3 = 4'b1111; // -1 (in 2's complement)
    parameter w4 = 4'b0001; // 0.5 (represented in fixed-point)
    parameter b = 4'b1101; // -1.5 (represented in fixed-point)

    wire signed [7:0] weighted_sum;

    assign weighted_sum = (w1*x[0] + w2*x[1] + w3*x[2] + w4*x[3]) + b;

    always @(*) begin
        if (weighted_sum > 0)
            y = 1;
        else
            y = 0;
    end
endmodule