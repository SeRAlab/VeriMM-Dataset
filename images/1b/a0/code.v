module kalman_filter (
    input clk,
    input reset,
    input [15:0] position_measurement,
    input [15:0] velocity_measurement,
    output reg [15:0] estimated_position,
    output reg [15:0] estimated_velocity
);
    reg [15:0] x_hat;   // State estimate (position)
    reg [15:0] v_hat;   // State estimate (velocity)
    reg [15:0] p;       // Estimate uncertainty
    reg [15:0] q;       // Process noise covariance
    reg [15:0] r;       // Measurement noise covariance
    reg [15:0] k;       // Kalman gain

    initial begin
        x_hat = 0;
        v_hat = 0;
        p = 16'hFFFF; // Initial estimate uncertainty
        q = 16'h0001; // Process noise
        r = 16'h0001; // Measurement noise
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            x_hat <= 0;
            v_hat <= 0;
            p <= 16'hFFFF;
        end else begin
            // Prediction step
            x_hat <= x_hat + v_hat; // Update position
            p <= p + q; // Update uncertainty

            // Update step
            k <= p / (p + r); // Compute Kalman gain
            x_hat <= x_hat + k * (position_measurement - x_hat); // Update position estimate
            v_hat <= v_hat + k * (velocity_measurement - v_hat); // Update velocity estimate
            p <= (1 - k) * p; // Update uncertainty
        end
    end

    always @(posedge clk) begin
        estimated_position <= x_hat;
        estimated_velocity <= v_hat;
    end
endmodule