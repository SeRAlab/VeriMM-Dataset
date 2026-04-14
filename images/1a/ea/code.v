module svm_classifier (
    input [7:0] feature1,
    input [7:0] feature2,
    output reg classification
);
    always @(*) begin
        // Calculate decision function
        if ((5 * feature1) + (-3 * feature2) + 2 >= 0) 
            classification = 1;
        else 
            classification = 0;
    end
endmodule