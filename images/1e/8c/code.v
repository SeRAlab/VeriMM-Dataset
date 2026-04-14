module gradient_descent_optimizer(  
    input [15:0] current_weights,  
    input [15:0] learning_rate,  
    input [15:0] gradient,  
    output [15:0] updated_weights  
);  
    assign updated_weights = current_weights - (learning_rate * gradient);  
endmodule