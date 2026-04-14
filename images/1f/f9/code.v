module LMS_Filter (
    input clk,
    input rst,
    input signed [15:0] x,      // Input signal
    input signed [15:0] d,      // Desired signal
    output signed [15:0] y,     // Output signal
    output signed [15:0] error   // Error signal
);
    parameter N = 4;            // Number of filter taps
    parameter STEP_SIZE = 16'h000A; // Step size (fixed value)
    
    reg signed [15:0] w [0:N-1]; // Weights
    reg signed [15:0] y_reg;      // Output signal
    reg signed [15:0] error_reg;  // Error signal
    
    integer i;
    
    // Initialize weights and outputs
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            for (i = 0; i < N; i = i + 1) 
                w[i] <= 16'h0000; // Clear weights
            y_reg <= 16'h0000; 
            error_reg <= 16'h0000; 
        end else begin
            // Compute output
            y_reg = 16'h0000;
            for (i = 0; i < N; i = i + 1) 
                y_reg = y_reg + (w[i] * x); // Assume x is delayed for each tap
            
            // Compute error
            error_reg = d - y_reg;
            
            // Update weights
            for (i = 0; i < N; i = i + 1) 
                w[i] = w[i] + (STEP_SIZE * error_reg * x); // Update weights based on the error
            
        end
    end
    
    assign y = y_reg;
    assign error = error_reg;
    
endmodule