module svm_classifier (
    input [1:0] x, // 2-bit input: x[1] = x1, x[0] = x2
    output reg y    // 1-bit output: class label
);
    always @(*) begin
        if ((1 * x[1] + 1 * x[0] - 1) > 0)
            y = 1;
        else
            y = 0;
    end
endmodule