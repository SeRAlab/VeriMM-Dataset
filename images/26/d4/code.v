module adaptive_lms_filter #(
    parameter N = 5, // Number of taps
    parameter STEP_SIZE = 8'h01 // Fixed step size
)(
    input clk,
    input reset,
    input signed [15:0] x, // Input signal
    input signed [15:0] d, // Desired signal
    output signed [15:0] y // Output signal
);
    reg signed [15:0] w[N-1:0]; // Coefficients
    reg signed [15:0] y_reg; // Output register
    integer i;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            for (i = 0; i < N; i = i + 1) begin
                w[i] <= 0; // Reset coefficients
            end
            y_reg <= 0;
        end else begin
            // Shift the coefficients
            for (i = N-1; i > 0; i = i - 1) begin
                w[i] <= w[i-1];
            end
            w[0] <= x; // Update first coefficient

            // Compute output
            y_reg <= 0;
            for (i = 0; i < N; i = i + 1) begin
                y_reg <= y_reg + (w[i] * w[i]);
            end

            // Update coefficients using LMS algorithm
            for (i = 0; i < N; i = i + 1) begin
                w[i] <= w[i] + ((d - y_reg) * x) / STEP_SIZE; // LMS update
            end
        end
    end

    assign y = y_reg; // Output assignment
endmodule