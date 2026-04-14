module gradient_descent(  
    input wire [15:0] current_position,  
    input wire [15:0] learning_rate,  
    output wire [15:0] updated_position  
);  
    // Hardcoded gradient value (for example, the gradient of f(x) = x^2 is 2x at x = current_position)  
    parameter GRADIENT_CONSTANT = 2;  
    wire [31:0] gradient;  
    wire [31:0] adjustment;  

    // Calculate the gradient at the current position  
    assign gradient = GRADIENT_CONSTANT * current_position;  
    // Calculate the adjustment using the learning rate  
    assign adjustment = (learning_rate * gradient) >> 8;  // Example of scaling down the adjustment  
    // Update the position  
    assign updated_position = current_position - adjustment[15:0];  
endmodule