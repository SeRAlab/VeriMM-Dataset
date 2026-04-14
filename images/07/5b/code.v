module gradient_descent_optimizer(  
    input clk,  
    input reset,  
    input [15:0] current_weight,  
    input [15:0] learning_rate,  
    input [15:0] gradient,  
    output reg [15:0] new_weight  
);  

always @(posedge clk or posedge reset) begin  
    if (reset) begin  
        new_weight <= 16'b0;  
    end else begin  
        new_weight <= current_weight - (learning_rate * gradient >> 8); // Shift to adjust for fixed-point multiplication  
    end  
end  
endmodule