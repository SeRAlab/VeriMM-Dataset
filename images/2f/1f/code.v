module kalman_filter(
    input clk,
    input rst,
    input [15:0] position_meas,
    input [15:0] velocity_meas,
    output reg [15:0] filtered_position,
    output reg [15:0] filtered_velocity
);

// Internal state variables
reg [15:0] x; // State vector [position; velocity]
reg [15:0] P; // Error covariance matrix
reg [15:0] Q; // Process noise covariance
reg [15:0] R; // Measurement noise covariance
reg [15:0] K; // Kalman gain

// Initialize parameters
initial begin
    x = 0;
    P = 16'hFFFF; // Large initial error
    Q = 16'h0001; // Process noise
    R = 16'h0001; // Measurement noise
end

always @(posedge clk or posedge rst) begin
    if (rst) begin
        // Reset state
        filtered_position <= 0;
        filtered_velocity <= 0;
        x <= 0;
        P <= 16'hFFFF;
    end else begin
        // Prediction update
        x[15:8] <= x[15:8] + (x[7:0] >> 8); // Update position
        x[7:0] <= x[7:0]; // Keep velocity same for simplicity
        P <= P + Q; // Update uncertainty

        // Measurement update
        K <= P / (P + R); // Compute Kalman gain
        x <= x + K * ({position_meas, velocity_meas} - x); // Update state
        P <= (16'hFFFF - K) * P; // Update uncertainty
        
        // Output filtered results
        filtered_position <= x[15:8];
        filtered_velocity <= x[7:0];
    end
end

endmodule