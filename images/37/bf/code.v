module logistic_regression(
    input [4:0] X,  // 5 binary inputs
    output reg Y     // binary output
);
    wire signed [7:0] weighted_sum;
    parameter signed [7:0] bias = -10;

    // Calculate weighted sum
    assign weighted_sum = (1 * X[0]) + (2 * X[1]) + (3 * X[2]) + (4 * X[3]) + (5 * X[4]) + bias;

    // Output logic for sigmoid approximation
    always @(*) begin
        if (weighted_sum >= 0) 
            Y = 1; 
        else 
            Y = 0; 
    end
endmodule