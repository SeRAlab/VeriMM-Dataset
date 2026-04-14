module kalman_filter (
    input clk,
    input rst,
    input [15:0] measurement, // Noisy sensor measurement
    input [15:0] control,     // Control input
    output reg [15:0] estimate // Estimated state output
);
    reg [15:0] x; // State estimate
    reg [15:0] p; // Estimate covariance
    reg [15:0] q; // Process noise covariance
    reg [15:0] r; // Measurement noise covariance
    reg [15:0] k; // Kalman gain

    // Initialize parameters
    initial begin
        x = 16'd0;
        p = 16'd1;
        q = 16'd1; // Process noise
        r = 16'd1; // Measurement noise
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            x <= 16'd0;
            p <= 16'd1;
        end else begin
            // Prediction update
            p <= p + q; // Update covariance

            // Measurement update
            k <= p / (p + r); // Kalman gain
            x <= x + k * (measurement - x); // Update state estimate
            p <= (1 - k) * p; // Update covariance
            
            estimate <= x; // Output the estimated state
        end
    end
endmodule