module backpropagation #(parameter INPUT_SIZE = 5, parameter WEIGHT_SIZE = 5) (  
    input clk,  
    input reset,  
    input [INPUT_SIZE-1:0] inputs,  
    input [WEIGHT_SIZE-1:0] weights,  
    input [WEIGHT_SIZE-1:0] target,  
    input [7:0] learning_rate,  
    output reg [WEIGHT_SIZE-1:0] updated_weights  
);  
    reg [WEIGHT_SIZE-1:0] error;  
    reg [WEIGHT_SIZE-1:0] delta;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            updated_weights <= 0;  
        end else begin  
            error = target - (weights * inputs);  
            delta = (error * learning_rate);  
            updated_weights <= weights + delta;  
        end  
    end  
endmodule