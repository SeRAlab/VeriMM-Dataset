module svm_classifier (
    input wire X1,
    input wire X2,
    output wire Y
);
    assign Y = (X1 + X2 > 1) ? 1 : 0; // Decision boundary at X1 + X2 = 2
endmodule