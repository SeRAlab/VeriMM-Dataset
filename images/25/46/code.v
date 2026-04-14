module svm_classifier(
    input [1:0] x1,
    input [1:0] x2,
    input [1:0] w1,
    input [1:0] w2,
    input [1:0] b,
    output reg decision
);
    always @(*) begin
        if ((w1 * x1 + w2 * x2 + b) > 0)
            decision = 1'b1;
        else
            decision = 1'b0;
    end
endmodule