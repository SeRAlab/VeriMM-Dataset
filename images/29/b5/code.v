module svm_classifier (
    input [7:0] feature1,
    input [7:0] feature2,
    input [7:0] feature3,
    input [7:0] feature4,
    input [7:0] feature5,
    output reg class_label
);
    
    // Hardcoded weights and bias for the linear decision function
    parameter [7:0] w1 = 8'd1;
    parameter [7:0] w2 = 8'd2;
    parameter [7:0] w3 = 8'd3;
    parameter [7:0] w4 = 8'd4;
    parameter [7:0] w5 = 8'd5;
    parameter [7:0] bias = 8'd10;

    always @(*) begin
        // Calculate the weighted sum
        if ((feature1 * w1 + feature2 * w2 + feature3 * w3 + feature4 * w4 + feature5 * w5) > bias) 
            class_label = 1'b1; // Class 1
        else 
            class_label = 1'b0; // Class 0
    end
endmodule