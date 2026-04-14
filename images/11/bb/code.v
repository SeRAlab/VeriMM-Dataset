module backpropagation #(parameter N = 5) (  
    input clk,  
    input reset,  
    input [N-1:0] weight_input,  
    input [N-1:0] error_gradient,  
    output reg [N-1:0] updated_weights  
);  
    reg [N-1:0] weights;  
  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            weights <= 0;  
            updated_weights <= 0;  
        end else begin  
            // A simple update rule: updated_weights = weights - learning_rate * error_gradient  
            // Assuming learning_rate is 1 for simplicity  
            updated_weights <= weights - error_gradient;  
            weights <= updated_weights;  
        end  
    end  
endmodule