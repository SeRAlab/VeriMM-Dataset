module svm_classifier (
    input [3:0] feature1,
    input [3:0] feature2,
    output reg class
);
    always @(*) begin
        // Example decision boundary: classify based on the sum of features
        if (feature1 + feature2 > 8)
            class = 1'b1; // Class 1
        else
            class = 1'b0; // Class 0
    end
endmodule