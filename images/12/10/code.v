module svm_classifier (
    input [7:0] feature_x,
    input [7:0] feature_y,
    output reg class_label
);

    // Hardcoded weights and bias
    parameter weight_x = 8'd2;   // weight for feature_x
    parameter weight_y = 8'd3;   // weight for feature_y
    parameter bias = 8'd1;        // bias term

    always @* begin
        // Decision function
        if ((weight_x * feature_x + weight_y * feature_y + bias) > 0) 
            class_label = 1'b1; // Class 1
        else 
            class_label = 1'b0; // Class 0
    end
endmodule