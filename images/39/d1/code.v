module adaptive_lms_filter (  
    input clk,  
    input reset,  
    input signed [15:0] x, // input signal  
    input signed [15:0] d, // desired signal  
    output reg signed [15:0] y // output signal  
);  
    parameter N = 5; // number of taps  
    parameter mu = 16'h0001; // step size  
  
    reg signed [15:0] w [0:N-1]; // filter coefficients  
    reg signed [15:0] x_history [0:N-1]; // input history  
    integer i;  
  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            for (i = 0; i < N; i = i + 1) begin  
                w[i] <= 16'h0000; // Initialize coefficients to zero  
            end  
            y <= 16'h0000; // Initialize output to zero  
        end else begin  
            // Shift input history  
            for (i = N-1; i > 0; i = i - 1) begin  
                x_history[i] <= x_history[i-1];  
            end  
            x_history[0] <= x; // Update latest input  
  
            // Calculate output  
            y <= 16'h0000;  
            for (i = 0; i < N; i = i + 1) begin  
                y <= y + (w[i] * x_history[i]);  
            end  
  
            // Update coefficients  
            for (i = 0; i < N; i = i + 1) begin  
                w[i] <= w[i] + (mu * (d - y) * x_history[i]);  
            end  
        end  
    end  
endmodule