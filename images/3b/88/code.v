module adaptive_lms_filter #(
    parameter NUM_TAPS = 5,
    parameter STEP_SIZE = 8'h01
)(
    input clk,
    input reset,
    input signed [15:0] x,         // Input signal
    input signed [15:0] d,         // Desired signal
    output reg signed [15:0] y      // Output signal
);

    reg signed [15:0] w [0:NUM_TAPS-1]; // Weights
    reg signed [15:0] e;                  // Error signal
    integer i;

    // Initialize weights
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            for (i = 0; i < NUM_TAPS; i = i + 1) begin
                w[i] <= 16'h0000; // Reset weights to zero
            end
            y <= 16'h0000; // Reset output
        end else begin
            // Calculate output y
            y <= 16'h0000; // Reset output for accumulation
            for (i = 0; i < NUM_TAPS; i = i + 1) begin
                y <= y + (w[i] * x); // Accumulate weighted input
            end

            // Calculate error
            e <= d - y; // Error signal

            // Update weights
            for (i = 0; i < NUM_TAPS; i = i + 1) begin
                w[i] <= w[i] + (STEP_SIZE * e * x); // Update weights
            end
        end
    end

endmodule