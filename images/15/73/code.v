module svm_classifier (
    input [7:0] x,
    input [7:0] y,
    output reg class
);
    // Fixed parameters for the decision boundary
    parameter m = 1;
    parameter b = 0;

    always @(*) begin
        if (y < (m * x + b)) begin
            class = 0; // Below the line
        end else begin
            class = 1; // Above or on the line
        end
    end
endmodule