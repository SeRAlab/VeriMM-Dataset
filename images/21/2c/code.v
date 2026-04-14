module logistic_regression(
    input [3:0] x1,  // Input feature 1
    input [3:0] x2,  // Input feature 2
    input [3:0] w1,  // Weight 1
    input [3:0] w2,  // Weight 2
    output reg result // Sigmoid output (0 or 1)
);
    wire signed [7:0] linear_combination; // To hold weighted sum
    wire signed [7:0] exp_neg;            // To hold exp(-linear_combination)
    wire signed [7:0] sigmoid_denom;      // To hold the denominator for sigmoid

    // Calculate linear combination: w1*x1 + w2*x2
    assign linear_combination = (w1 * x1) + (w2 * x2);
    
    // Calculate exp(-linear_combination) (approximation using shift)
    assign exp_neg = 8'b1 << (linear_combination < 0 ? -linear_combination : 0); // Simulate exp(-x) using bit shift

    // Calculate sigmoid denominator: 1 + exp(-linear_combination)
    assign sigmoid_denom = 8'b1 + exp_neg;

    // Output result: if sigmoid value >= 0.5, output 1, else output 0
    always @(*) begin
        if (sigmoid_denom != 0) begin
            if (8'b1 >= sigmoid_denom) 
                result = 1'b1;
            else 
                result = 1'b0;
        end else
            result = 1'b0;
    end
endmodule