module gradient_descent_optimizer(  
    input clk,  
    input reset,  
    input [15:0] current_position,  
    input [15:0] learning_rate,  
    output reg [15:0] next_position  
);  
    reg [15:0] gradient;  
    
    initial begin  
        gradient = 16'd1; // Fixed gradient value  
    end  
    
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            next_position <= 16'd0;  
        end else begin  
            next_position <= current_position - (learning_rate * gradient);  
        end  
    end  
endmodule