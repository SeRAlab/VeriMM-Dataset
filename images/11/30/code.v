module svm_classifier (
    input signed [7:0] x1,
    input signed [7:0] x2,
    input signed [7:0] w1,
    input signed [7:0] w2,
    input signed [7:0] b,
    output reg classification
);
    
    always @(*) begin
        if ((w1 * x1 + w2 * x2 + b) > 0)
            classification = 1;
        else
            classification = 0;
    end
endmodule