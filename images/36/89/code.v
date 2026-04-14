module neural_network(clk, reset, input1, input2, expected_output, output_signal);  
    input clk, reset;  
    input [7:0] input1, input2;  
    input [7:0] expected_output;  
    output reg [7:0] output_signal;  

    reg [7:0] w1, w2; // weights  
    reg [7:0] hidden_layer;  
    reg [7:0] output_layer;  
    reg signed [15:0] error;  
    reg signed [15:0] learning_rate = 8;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            w1 <= 8'd1;  
            w2 <= 8'd1;  
            output_signal <= 8'd0;  
        end else begin  
            // Forward pass  
            hidden_layer <= (input1 * w1) + (input2 * w2);  
            output_layer <= (hidden_layer > 8'd0) ? hidden_layer : 8'd0; // ReLU activation  
            output_signal <= output_layer;  

            // Backpropagation  
            error <= expected_output - output_signal;  
            w1 <= w1 + (learning_rate * error * input1) >> 8;  
            w2 <= w2 + (learning_rate * error * input2) >> 8;  
        end  
    end  
endmodule