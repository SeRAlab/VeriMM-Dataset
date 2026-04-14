module svm_classifier (
    input [7:0] feature1,
    input [7:0] feature2,
    input weight,
    output reg classification
);
    parameter THRESHOLD = 8'd100; // Define a threshold for classification

    always @(*) begin
        if (weight) begin
            // Class 1
            classification = (feature1 + feature2 > THRESHOLD) ? 1'b1 : 1'b0;
        end else begin
            // Class 0
            classification = (feature1 + feature2 <= THRESHOLD) ? 1'b0 : 1'b1;
        end
    end
endmodule