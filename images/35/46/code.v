module rnn_cell #(parameter INPUT_SIZE = 3, parameter HIDDEN_SIZE = 2) (  
    input clk,  
    input reset,  
    input enable,  
    input [INPUT_SIZE-1:0] input_vector,  
    input [HIDDEN_SIZE-1:0] hidden_state,  
    output reg [HIDDEN_SIZE-1:0] new_hidden_state,  
    output reg [HIDDEN_SIZE-1:0] output_vector  
);  
    // Weight matrix and bias for the RNN cell  
    reg [HIDDEN_SIZE-1:0] weight_matrix [0:INPUT_SIZE-1];  
    reg [HIDDEN_SIZE-1:0] bias;  

    initial begin  
        // Initialize weights and biases (example values)  
        weight_matrix[0] = 2'b01;  
        weight_matrix[1] = 2'b10;  
        weight_matrix[2] = 2'b11;  
        bias = 2'b01;  
    end  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            new_hidden_state <= 0;  
            output_vector <= 0;  
        end else if (enable) begin  
            // Compute new hidden state  
            new_hidden_state <= (weight_matrix[0] * input_vector[0]) +  
                                (weight_matrix[1] * input_vector[1]) +  
                                (weight_matrix[2] * input_vector[2]) + bias;  
            // Output is the new hidden state (simple case)  
            output_vector <= new_hidden_state;  
        end  
    end  
endmodule