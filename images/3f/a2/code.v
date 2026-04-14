module gradient_descent_optimizer(  
    input clk,  
    input [15:0] current_weight,  
    input [15:0] learning_rate,  
    input [15:0] gradient,  
    output reg [15:0] new_weight  
);  
    always @(posedge clk) begin  
        new_weight <= current_weight - (learning_rate * gradient);  
    end  
endmodule