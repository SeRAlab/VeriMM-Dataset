module adaptive_lms_filter (
    input clk,
    input rst,
    input signed [15:0] x,       // Input signal
    input signed [15:0] d,       // Desired output
    output signed [15:0] y        // Filtered output
);
    parameter N = 5;              // Number of taps
    parameter signed [15:0] mu = 16'h0001; // Step size for weight update
    
    reg signed [15:0] w [0:N-1];  // Weights
    reg signed [15:0] x_delay [0:N-1]; // Delay line
    reg signed [15:0] y_reg;       // Output signal

    integer i;

    // Initialize weights and delay line on reset
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            for (i = 0; i < N; i = i + 1) begin
                w[i] <= 16'h0000;     // Initialize weights to zero
                x_delay[i] <= 16'h0000; // Initialize delay line to zero
            end
            y_reg <= 16'h0000;       // Initialize output to zero
        end else begin
            // Update delay line
            x_delay[0] <= x;
            for (i = 1; i < N; i = i + 1) begin
                x_delay[i] <= x_delay[i-1];
            end
            
            // Calculate output
            y_reg <= 0;
            for (i = 0; i < N; i = i + 1) begin
                y_reg <= y_reg + (w[i] * x_delay[i]);
            end
            
            // Update weights
            for (i = 0; i < N; i = i + 1) begin
                w[i] <= w[i] + (mu * (d - y_reg) * x_delay[i]);
            end
        end
    end
    
    assign y = y_reg; // Assign output

endmodule