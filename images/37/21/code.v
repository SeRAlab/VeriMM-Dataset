module NeuralLayer #(parameter N = 3, parameter LEARNING_RATE = 8'b00000001) (  
    input clk,  
    input reset,  
    input [N-1:0] inputs,  
    input [N-1:0] weights,  
    input signed [7:0] bias,  
    input signed [7:0] expected_output,  
    output reg signed [7:0] output_value,  
    output reg [N-1:0] new_weights,  
    output reg signed [7:0] new_bias  
);  
    reg signed [7:0] weighted_sum;  
    reg signed [7:0] error;  
    integer i;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            output_value <= 0;  
            new_weights <= 0;  
            new_bias <= 0;  
        end else begin  
            // Calculate weighted sum  
            weighted_sum = bias;  
            for (i = 0; i < N; i = i + 1) begin  
                weighted_sum = weighted_sum + (inputs[i] * weights[i]);  
            end  
            output_value <= weighted_sum;  

            // Calculate error  
            error = expected_output - output_value;  

            // Update weights and bias  
            for (i = 0; i < N; i = i + 1) begin  
                new_weights[i] <= weights[i] + (error * inputs[i] * LEARNING_RATE) >>> 8;  
            end  
            new_bias <= bias + (error * LEARNING_RATE) >>> 8;  
        end  
    end  
endmodule