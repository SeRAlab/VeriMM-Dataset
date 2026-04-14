module svm_classifier (
    input [3:0] feature_x,
    input [3:0] feature_y,
    output reg class
);

always @(*) begin
    // Decision boundary: y = x - 5
    // Class 1 if feature_y > feature_x - 5 else Class 0
    if (feature_y > feature_x - 4'b0101) // 5 in decimal is 0101 in binary
        class = 1'b1; // Class 1
    else
        class = 1'b0; // Class 0
end

endmodule