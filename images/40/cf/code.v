module nn_backpropagation (  
    input clk,  
    input [7:0] x1,  
    input [7:0] x2,  
    input [7:0] target,  
    output reg [7:0] weight1,  
    output reg [7:0] weight2,  
    output reg [7:0] output_val  
);  
    reg [7:0] output_temp;  
    reg [15:0] error;  
    reg [15:0] learning_rate = 8; // Fixed learning rate  

    always @(posedge clk) begin  
        // Compute output  
        output_temp = (weight1 * x1 + weight2 * x2) >> 8;  
        output_val <= output_temp;  

        // Calculate error  
        error = target - output_temp;  

        // Update weights  
        weight1 <= weight1 + (error * x1 * learning_rate >> 8);  
        weight2 <= weight2 + (error * x2 * learning_rate >> 8);  
    end  
endmodule