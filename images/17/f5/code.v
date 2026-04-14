module simple_neuron #(parameter LEARNING_RATE = 8'b00000001) (  
    input clk,  
    input reset,  
    input [7:0] x1,  
    input [7:0] x2,  
    input [7:0] x3,  
    input [7:0] target,  
    output reg [7:0] output_signal,  
    output reg [7:0] w1,  
    output reg [7:0] w2,  
    output reg [7:0] w3,  
    output reg [7:0] bias  
);  
    reg [7:0] error;  
    reg [7:0] output_temp;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            w1 <= 8'b00000001;  
            w2 <= 8'b00000001;  
            w3 <= 8'b00000001;  
            bias <= 8'b00000000;  
            output_signal <= 8'b00000000;  
        end else begin  
            // Compute output  
            output_temp = (x1 * w1 + x2 * w2 + x3 * w3 + bias);  
            output_signal <= output_temp;  

            // Compute error  
            error = target - output_temp;  

            // Update weights and bias  
            w1 <= w1 + (error * x1) >> 8;  
            w2 <= w2 + (error * x2) >> 8;  
            w3 <= w3 + (error * x3) >> 8;  
            bias <= bias + (error) >> 8;  
        end  
    end  
endmodule