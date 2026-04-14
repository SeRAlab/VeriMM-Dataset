module svm_classifier (
    input [2:0] feature1, // First feature vector
    input [2:0] feature2, // Second feature vector
    output reg class_label // Output class label (0 or 1)
);
    always @(*) begin
        // Decision boundary: If (feature1 + feature2) > 3, classify as 1 else classify as 0
        if ((feature1 + feature2) > 3)
            class_label = 1;
        else
            class_label = 0;
    end
endmodule