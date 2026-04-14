module adaptive_lms_filter #(parameter N = 4, parameter STEP_SIZE = 8'b00000001) (  
    input clk,  
    input reset,  
    input enable,  
    input signed [15:0] x, // input signal  
    input signed [15:0] d, // desired signal  
    output reg signed [15:0] y // output signal  
);  
    reg signed [15:0] w [0:N-1]; // filter coefficients  
    reg signed [15:0] x_delay [0:N-1]; // delay line for input signal  
    integer i;  

    // Initialize coefficients  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            for (i = 0; i < N; i = i + 1) begin  
                w[i] <= 16'b0;  
                x_delay[i] <= 16'b0;  
            end  
        end else if (enable) begin  
            // Shift the input signal through the delay line  
            x_delay[0] <= x;  
            for (i = 1; i < N; i = i + 1) begin  
                x_delay[i] <= x_delay[i-1];  
            end  

            // Compute the output signal  
            y <= 0;  
            for (i = 0; i < N; i = i + 1) begin  
                y <= y + (w[i] * x_delay[i]);  
            end  

            // Update the coefficients using LMS  
            for (i = 0; i < N; i = i + 1) begin  
                w[i] <= w[i] + (STEP_SIZE * (d - y) * x_delay[i]);  
            end  
        end  
    end  
endmodule