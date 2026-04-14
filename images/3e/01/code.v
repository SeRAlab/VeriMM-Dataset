module neural_backpropagation (  
    input clk,  
    input reset,  
    input [7:0] input_data,  
    input [7:0] target_output,  
    input [7:0] learning_rate,  
    output reg [7:0] weight,  
    output reg [7:0] output_data  
);  
    reg [7:0] error;  
    reg [7:0] output_activation;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            weight <= 8'd0;  
            output_data <= 8'd0;  
        end else begin  
            // Forward pass  
            output_data <= (input_data * weight);  
            // Apply ReLU activation  
            output_activation <= (output_data > 8'd0) ? output_data : 8'd0;  
            // Backpropagation  
            error <= target_output - output_activation;  
            // Update weight  
            weight <= weight + (error * learning_rate);  
        end  
    end  
endmodule