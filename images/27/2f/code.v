module svm_classifier (
    input [4:0] features,  // 5-bit input feature vector
    output reg classification // 1-bit output classification
);

    // Define weights and bias based on a simple decision boundary
    parameter [4:0] w0 = 5'b00001; // Weight for feature 0
    parameter [4:0] w1 = 5'b00010; // Weight for feature 1
    parameter [4:0] w2 = 5'b00011; // Weight for feature 2
    parameter [4:0] w3 = 5'b00100; // Weight for feature 3
    parameter [4:0] w4 = 5'b00101; // Weight for feature 4
    parameter signed [5:0] bias = 6'b000010; // Bias term

    always @(*) begin
        // Calculate the decision function
        if (features * w0 + features * w1 + features * w2 + features * w3 + features * w4 + bias > 0)
            classification = 1'b1; // Class 1
        else
            classification = 1'b0; // Class 0
    end
endmodule