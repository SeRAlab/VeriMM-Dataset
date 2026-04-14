module lms_filter (
    input clk,
    input reset,
    input signed [15:0] x, // Input signal
    input signed [15:0] d, // Desired signal
    output signed [15:0] y, // Filter output
    output signed [15:0] w // Coefficient output
);
    parameter mu = 16'h0001; // Step size
    reg signed [15:0] w0, w1, w2; // Filter coefficients
    reg signed [15:0] y_reg;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            w0 <= 0;
            w1 <= 0;
            w2 <= 0;
            y_reg <= 0;
        end else begin
            // Calculate filter output
            y_reg <= (w0 * x) + (w1 * x) + (w2 * x);
            // Update coefficients
            w0 <= w0 + (mu * (d - y_reg) * x);
            w1 <= w1 + (mu * (d - y_reg) * x);
            w2 <= w2 + (mu * (d - y_reg) * x);
        end
    end

    assign y = y_reg;
    assign w = {w0, w1, w2}; // Concatenate coefficients for output
endmodule