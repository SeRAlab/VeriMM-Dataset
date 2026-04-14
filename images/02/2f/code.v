module adaptive_lms_filter #(parameter N = 5, parameter STEP_SIZE = 8'b00000001) (  
    input clk,  
    input signed [15:0] x, // Input signal  
    input signed [15:0] d, // Desired signal  
    output reg signed [15:0] y, // Filter output  
    output reg signed [15:0] e // Error signal  
);  
    reg signed [15:0] w [0:N-1]; // Coefficients  
    reg signed [15:0] x_buf [0:N-1]; // Input buffer  
    integer i;  
   
    // Initialize coefficients and buffers  
    initial begin  
        for (i = 0; i < N; i = i + 1) begin  
            w[i] = 16'b0;  
            x_buf[i] = 16'b0;  
        end  
    end  

    always @(posedge clk) begin  
        // Shift input buffer  
        for (i = N-1; i > 0; i = i - 1) begin  
            x_buf[i] <= x_buf[i-1];  
        end  
        x_buf[0] <= x;  

        // Compute filter output  
        y <= 0;  
        for (i = 0; i < N; i = i + 1) begin  
            y <= y + (w[i] * x_buf[i]);  
        end  

        // Compute error signal  
        e <= d - y;  

        // Update coefficients  
        for (i = 0; i < N; i = i + 1) begin  
            w[i] <= w[i] + (STEP_SIZE * e * x_buf[i]);  
        end  
    end  
endmodule