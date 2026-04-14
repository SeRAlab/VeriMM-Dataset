module backpropagation #(parameter N = 5) (  
    input clk,  
    input [N-1:0] inputs,  
    input [N-1:0] expected_output,  
    input [N-1:0] weights,  
    input [3:0] learning_rate,  
    output reg [N-1:0] updated_weights  
);  
    reg [N-1:0] error;  
    reg [N-1:0] gradient;  
    integer i;  
    
    always @(posedge clk) begin  
        // Compute error  
        error = expected_output - inputs;  
        
        // Compute gradient  
        for (i = 0; i < N; i = i + 1) begin  
            gradient[i] = error[i];  
        end  

        // Update weights  
        for (i = 0; i < N; i = i + 1) begin  
            updated_weights[i] = weights[i] + (gradient[i] * learning_rate);  
        end  
    end  
endmodule