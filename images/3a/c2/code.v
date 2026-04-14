module adaptive_lms(
    input clk,
    input signed [15:0] x, // input signal
    input signed [15:0] d, // desired signal
    input signed [15:0] mu, // step size
    output reg signed [15:0] y, // filter output
    output reg signed [15:0] e // error signal
);
    reg signed [15:0] w0, w1; // coefficients
    reg signed [15:0] x_reg;

    always @(posedge clk) begin
        // Calculate filter output
        y <= (w0 * x_reg) + (w1 * x);
        
        // Calculate error signal
        e <= d - y;

        // Update coefficients (LMS algorithm)
        w0 <= w0 + (mu * e * x_reg) >>> 8; // right shift for scaling
        w1 <= w1 + (mu * e * x) >>> 8; // right shift for scaling

        // Register x for next calculation
        x_reg <= x;
    end
endmodule