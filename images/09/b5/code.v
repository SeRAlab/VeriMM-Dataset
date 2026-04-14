module svm_classifier (
    input [7:0] x1,    // First feature input
    input [7:0] x2,    // Second feature input
    input [7:0] w1,    // Weight for the first feature
    input [7:0] w2,    // Weight for the second feature
    input [7:0] b,     // Bias term
    output reg class    // Output class (0 or 1)
);

always @(*) begin
    if ((w1 * x1 + w2 * x2 + b) > 8'b0) 
        class = 1'b1; 
    else 
        class = 1'b0;
end

endmodule