module svm_classifier (
    input [4:0] x1, // Input feature 1
    input [4:0] x2, // Input feature 2
    input [4:0] x3, // Input feature 3
    input [4:0] x4, // Input feature 4
    input [4:0] x5, // Input feature 5
    input [4:0] w1, // Weight 1
    input [4:0] w2, // Weight 2
    input [4:0] w3, // Weight 3
    input [4:0] w4, // Weight 4
    input [4:0] w5, // Weight 5
    input signed [4:0] b, // Bias
    output reg y // Output class
);
    wire signed [5:0] decision_value;

    assign decision_value = (x1 * w1) + (x2 * w2) + (x3 * w3) + (x4 * w4) + (x5 * w5) + b;

    always @(*) begin
        if (decision_value > 0) begin
            y = 1; // Class 1
        end else begin
            y = 0; // Class 0
        end
    end
endmodule