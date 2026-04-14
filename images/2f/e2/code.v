module simple_neural_network_layer #(parameter INPUT_SIZE = 5, parameter WEIGHT_SIZE = 5, parameter BIAS_SIZE = 1) (  
    input [INPUT_SIZE-1:0] inputs,  
    input [WEIGHT_SIZE-1:0] weights,  
    input [BIAS_SIZE-1:0] bias,  
    output reg [7:0] output_signal  
);  
    integer i;  
    reg [15:0] sum;  

    always @(*) begin  
        sum = 0;  
        for (i = 0; i < INPUT_SIZE; i = i + 1) begin  
            sum = sum + inputs[i] * weights[i];  
        end  
        sum = sum + bias;  
        output_signal = (sum > 0) ? sum[7:0] : 8'b0; // ReLU activation  
    end  
endmodule