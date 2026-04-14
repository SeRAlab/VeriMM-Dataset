module Backpropagation #(parameter WIDTH = 16) (  
    input clk,  
    input [WIDTH-1:0] weights,  
    input [WIDTH-1:0] gradients,  
    input [WIDTH-1:0] learning_rate,  
    output reg [WIDTH-1:0] updated_weights  
);  
    always @(posedge clk) begin  
        updated_weights <= weights - (gradients * learning_rate);  
    end  
endmodule