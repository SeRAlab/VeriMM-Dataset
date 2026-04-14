module gradient_descent(  
    input signed [31:0] x,      // Current value  
    input signed [31:0] alpha,   // Learning rate  
    input signed [31:0] grad,    // Gradient  
    output signed [31:0] x_new    // Updated value  
);  
    assign x_new = x - (alpha * grad);  
endmodule