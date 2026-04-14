module kalman_filter (
    input clk,
    input rst,
    input [15:0] measurement,
    output reg [15:0] estimated_position,
    output reg [15:0] estimated_velocity
);
    reg [15:0] current_estimate;
    reg [15:0] current_velocity;

    // Kalman filter parameters
    parameter [15:0] process_noise = 16'd1;  // Process noise covariance
    parameter [15:0] measurement_noise = 16'd10; // Measurement noise covariance
    parameter [15:0] kalman_gain = 16'd1;  // Kalman gain (simplified)

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            estimated_position <= 16'd0;
            estimated_velocity <= 16'd0;
            current_estimate <= 16'd0;
            current_velocity <= 16'd0;
        end else begin
            // Prediction step
            current_estimate <= estimated_position + estimated_velocity; // Update position
            current_velocity <= estimated_velocity; // Keep velocity constant

            // Update step
            estimated_position <= current_estimate + (kalman_gain * (measurement - current_estimate));
            estimated_velocity <= current_velocity; // Velocity remains constant (for simplification)
        end
    end
endmodule