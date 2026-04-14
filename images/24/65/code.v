module neural_network_layer (  
    input [3:0] input_vector,  
    input [3:0] weights,  
    input control, // 0 for forward pass, 1 for backward pass  
    output reg [3:0] output_vector,  
    output reg [3:0] updated_weights  
);  
    reg [3:0] output_temp;  
    reg [3:0] error;  
    parameter LEARNING_RATE = 1;  
  
    always @(posedge control) begin  
        if (control == 0) begin // Forward pass  
            output_temp = input_vector * weights;  
            output_vector = output_temp;  
        end else begin // Backward pass  
            error = output_vector - input_vector;  
            updated_weights = weights - (LEARNING_RATE * error);  
        end  
    end  
endmodule