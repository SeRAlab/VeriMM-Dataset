module adaptive_lms_filter #(parameter N = 4)(
    input clk,
    input reset,
    input signed [15:0] x, // input signal
    input signed [15:0] d, // desired signal
    input signed [15:0] mu, // learning rate
    output reg signed [15:0] y // output signal
);
    reg signed [15:0] w [0:N-1]; // filter coefficients
    reg signed [15:0] e; // error signal
    integer i;

    // Initialization
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            for (i = 0; i < N; i = i + 1) begin
                w[i] <= 16'h0000; // initialize weights to zero
            end
            y <= 16'h0000; // initialize output to zero
        end else begin
            e <= d - y; // error calculation
            y <= 0; // reset output
            // Update output and weights
            for (i = 0; i < N; i = i + 1) begin
                y <= y + (w[i] * x); // filtered output calculation
                w[i] <= w[i] + (mu * e * x); // weight update
            end
        end
    end
endmodule