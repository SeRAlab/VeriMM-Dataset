module SVM_Classifier (
    input clk,
    input reset,
    input [7:0] feature1,
    input [7:0] feature2,
    input [7:0] weight1,
    input [7:0] weight2,
    input [7:0] bias,
    output reg label
);
    reg [15:0] decision_value;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            label <= 1'b0;
            decision_value <= 16'b0;
        end else begin
            decision_value <= (feature1 * weight1) + (feature2 * weight2) + bias;
            if (decision_value > 16'b0) begin
                label <= 1'b1; // Class 1
            end else begin
                label <= 1'b0; // Class 0
            end
        end
    end
endmodule