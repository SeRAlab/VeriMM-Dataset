module svm_classifier(
    input [2:0] feature1,
    input [2:0] feature2,
    output reg decision
);
    always @(*) begin
        if ((feature1 * 2 + feature2 * 3) > 5)
            decision = 1;
        else
            decision = 0;
    end
endmodule