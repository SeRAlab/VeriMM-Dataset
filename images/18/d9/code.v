module gradient_descent (  
    input clk,  
    input reset,  
    input [15:0] old_position,  
    input [15:0] learning_rate,  
    input [15:0] gradient,  
    output reg [15:0] new_position  
);  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            new_position <= 16'd0;  
        end else begin  
            new_position <= old_position - (learning_rate * gradient >> 8); // Simple fixed-point multiplication  
        end  
    end  
endmodule