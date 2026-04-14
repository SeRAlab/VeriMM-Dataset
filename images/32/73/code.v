module simple_neuron (  
    input clk,  
    input reset,  
    input [15:0] x1,  
    input [15:0] x2,  
    input [15:0] target_output,  
    output reg [15:0] output_neuron  
);  

    reg [15:0] w1 = 16'h0001;  
    reg [15:0] w2 = 16'h0001;  
    reg [15:0] z;  
    reg [15:0] sigmoid_output;  
    parameter learning_rate = 16'h0001;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            w1 <= 16'h0001;  
            w2 <= 16'h0001;  
            output_neuron <= 16'h0000;  
        end else begin  
            z <= (x1 * w1 + x2 * w2) >> 8; // Fixed point multiplication  
            sigmoid_output <= (16'h0001 / (16'h0001 + (16'h0001 << -z))) >> 8; // Sigmoid approximation  
            output_neuron <= sigmoid_output;  

            // Backpropagation weight update  
            w1 <= w1 + (learning_rate * (target_output - sigmoid_output) * x1) >> 8;  
            w2 <= w2 + (learning_rate * (target_output - sigmoid_output) * x2) >> 8;  
        end  
    end  
endmodule