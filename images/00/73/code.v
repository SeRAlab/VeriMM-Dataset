module svm_classifier(
    input wire feature1,
    input wire feature2,
    output wire classification
);
    // Simple linear decision boundary: classification if feature1 + feature2 > 1
    assign classification = (feature1 + feature2) > 1 ? 1'b1 : 1'b0;
endmodule