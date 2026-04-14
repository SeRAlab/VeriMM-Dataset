module kalman_filter (
    input wire clk,
    input wire reset,
    input wire [15:0] sensor1_measurement, // Position
    input wire [15:0] sensor2_measurement, // Velocity
    output reg [15:0] estimated_position,
    output reg [15:0] estimated_velocity
);

    // Define fixed Kalman gain for simplicity
    parameter K_pos = 16'h0001; // Kalman gain for position
    parameter K_vel = 16'h0001; // Kalman gain for velocity

    // State variables
    reg [15:0] position_estimate;
    reg [15:0] velocity_estimate;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Reset estimates to zero
            position_estimate <= 16'h0000;
            velocity_estimate <= 16'h0000;
        end else begin
            // Update estimates based on measurements
            position_estimate <= position_estimate + K_pos * (sensor1_measurement - position_estimate);
            velocity_estimate <= velocity_estimate + K_vel * (sensor2_measurement - velocity_estimate);
        end
    end

    // Assign outputs
    always @(posedge clk) begin
        estimated_position <= position_estimate;
        estimated_velocity <= velocity_estimate;
    end

endmodule