module SVM_Classifier (
    input signed [7:0] x1,
    input signed [7:0] x2,
    input enable,
    output reg class_out
);
    parameter signed [7:0] W1 = 8'd1;
    parameter signed [7:0] W2 = -8'd1;
    parameter signed [7:0] bias = 8'd0;

    always @(*) begin
        if (enable) begin
            if ((W1 * x1 + W2 * x2 + bias) > 0)
                class_out = 1'b1; // Class 1
            else
                class_out = 1'b0; // Class 0
        end else begin
            class_out = 1'b0; // Default output when not enabled
        end
    end
endmodule