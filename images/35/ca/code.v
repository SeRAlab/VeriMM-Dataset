module gradient_descent (
    input [15:0] x,
    input [15:0] alpha,
    input [15:0] grad,
    output [15:0] x_new
);
    assign x_new = x - (alpha * grad) >> 8; // Assume alpha and grad are scaled
endmodule