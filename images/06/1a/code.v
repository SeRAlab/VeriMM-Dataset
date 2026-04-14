module kalman_filter (
    input clk,
    input reset,
    input [15:0] measurement,  // Noisy measurement
    input [15:0] control,      // Control input (velocity)
    output reg [15:0] position_estimate // Estimated position output
);

    // Internal variables
    reg [15:0] x;  // State estimate
    reg [15:0] p;  // Estimate error covariance
    reg [15:0] q;  // Process noise covariance
    reg [15:0] r;  // Measurement noise covariance
    reg [15:0] k;  // Kalman gain

    initial begin
        x = 16'h0; // Initial state
        p = 16'h1; // Initial estimate error
        q = 16'h1; // Process noise (tunable)
        r = 16'h1; // Measurement noise (tunable)
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            x <= 16'h0;
            p <= 16'h1;
        end else begin
            // Prediction update
            x <= x + control; // Control input affects state
            p <= p + q;       // Increase error covariance

            // Measurement update
            k <= p / (p + r); // Calculate Kalman gain
            x <= x + k * (measurement - x); // Update state estimate
            p <= (16'hFFFF - k) * p; // Update error covariance

            position_estimate <= x; // Output estimated position
        end
    end
endmodule