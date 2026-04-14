module svm_classifier (
    input signed [7:0] feature1,
    input signed [7:0] feature2,
    output reg class_output
);

parameter signed [7:0] weight1 = 8'd10;  // Weight for feature1
parameter signed [7:0] weight2 = 8'd5;   // Weight for feature2
parameter signed [7:0] bias = 8'd15;      // Bias

always @(*) begin
    // Calculate the decision function
    if ((weight1 * feature1 + weight2 * feature2 + bias) > 0)
        class_output = 1'b1;  // Class 1
    else
        class_output = 1'b0;  // Class 0
end

endmodule