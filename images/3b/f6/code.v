module svm_classifier(
    input [3:0] feature1,
    input [3:0] feature2,
    output reg class_out
);
    always @(*) begin
        // Compute the decision function
        if ((2 * feature1 + 3 * feature2 - 5) >= 0)
            class_out = 1'b1; // Class 1
        else
            class_out = 1'b0; // Class 0
    end
endmodule