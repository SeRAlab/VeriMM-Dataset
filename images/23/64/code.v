module gradient_descent(  
    input [15:0] current_value,  
    input [15:0] learning_rate,  
    input [15:0] gradient,  
    output [15:0] new_value  
);  
    assign new_value = current_value - (learning_rate * gradient >> 8); // right shift to adjust for fixed-point  
endmodule