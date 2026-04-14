module gradient_descent(clk, reset, current_position, learning_rate, updated_position);  
    input clk;  
    input reset;  
    input [15:0] current_position;  // fixed-point representation  
    input [15:0] learning_rate;     // fixed-point representation  
    output reg [15:0] updated_position;  

    reg [31:0] gradient;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            updated_position <= 16'b0;  
        end else begin  
            // Gradient: f'(x) = 2 * current_position  
            gradient <= current_position * 2;  
            // Update position: new_position = current_position - learning_rate * gradient  
            updated_position <= current_position - (learning_rate * gradient[15:0] >> 8);  
        end  
    end  
endmodule