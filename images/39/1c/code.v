module svm_classifier (
    input [3:0] x1,  // 4-bit input for feature x1
    input [3:0] x2,  // 4-bit input for feature x2
    output reg result  // 1-bit output for classification result
);
    always @(*) begin
        if ((2 * x1 + 3 * x2) >= 6)
            result = 1;
        else
            result = 0;
    end
endmodule