module svm_classifier (
    input [1:0] feature1,
    input [1:0] feature2,
    output reg class_out
);
    // We will use a simple linear decision boundary: 
    // class_out = 1 if feature1 + feature2 > 2, else class_out = 0
    always @(*) begin
        if (feature1 + feature2 > 2)
            class_out = 1;
        else
            class_out = 0;
    end
endmodule