module gradient_descent_optimizer(  
    input clk,  
    input rst,  
    input [15:0] gradient,  
    output reg [15:0] weight  
);  
    parameter LEARNING_RATE = 16'h0001; // Fixed learning rate for simplicity  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            weight <= 16'h0000; // Reset weight to zero  
        end else begin  
            weight <= weight + (gradient * LEARNING_RATE); // Update weight  
        end  
    end  
endmodule