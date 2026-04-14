module svm_classifier (
    input wire [1:0] x, // Two input features
    output wire y       // Output class
);
    parameter threshold = 1;

    assign y = (x[0] + x[1] > threshold) ? 1'b1 : 1'b0;
endmodule