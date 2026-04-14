module adaptive_lms_filter #(parameter N = 5, parameter STEP_SIZE = 8'h01) (  
    input clk,  
    input rst,  
    input signed [15:0] x,          // Input signal  
    input signed [15:0] d,          // Desired signal  
    output reg signed [15:0] y,      // Filtered output  
    output reg signed [15:0] error    // Error signal  
);  
    reg signed [15:0] w [0:N-1];     // Coefficients  
    reg signed [15:0] x_buffer [0:N-1]; // Input buffer  

    integer i;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            for (i = 0; i < N; i = i + 1) begin  
                w[i] <= 16'b0;  
                x_buffer[i] <= 16'b0;  
            end  
            y <= 16'b0;  
            error <= 16'b0;  
        end else begin  
            // Shift input buffer  
            x_buffer[0] <= x;  
            for (i = 1; i < N; i = i + 1) begin  
                x_buffer[i] <= x_buffer[i-1];  
            end  

            // Compute output  
            y <= 0;  
            for (i = 0; i < N; i = i + 1) begin  
                y <= y + (w[i] * x_buffer[i]);  
            end  

            // Compute error  
            error <= d - y;  

            // Update weights  
            for (i = 0; i < N; i = i + 1) begin  
                w[i] <= w[i] + (STEP_SIZE * error * x_buffer[i]);  
            end  
        end  
    end  
endmodule