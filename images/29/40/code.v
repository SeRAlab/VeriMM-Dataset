module gradient_descent(
    input  [31:0] x,      // current parameter value
    input  [31:0] alpha,  // learning rate
    input  [31:0] grad,   // gradient
    output [31:0] x_new   // updated parameter value
);
    assign x_new = x - (alpha * grad);
endmodule