module gradient_descent (  
    input clk,  
    input rst,  
    input [7:0] x_in,  // Current value of x  
    input [7:0] learning_rate, // Learning rate  
    output reg [7:0] x_out // Updated value of x  
);  
    reg [7:0] gradient;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            x_out <= 8'b0;  
        end else begin  
            // Gradient of f(x) = 2*(x - 3)  
            gradient <= (x_in > 3) ? (x_in - 3) : (3 - x_in);  
            // Update x using gradient descent  
            if (x_in > 3)  
                x_out <= x_in - (gradient * learning_rate) >> 3; // shifting for scaling  
            else  
                x_out <= x_in + (gradient * learning_rate) >> 3;  
        end  
    end  
endmodule