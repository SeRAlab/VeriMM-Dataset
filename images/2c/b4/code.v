module KalmanFilter (
    input clk,
    input rst,
    input [15:0] z1, // Sensor 1 measurement
    input [15:0] z2, // Sensor 2 measurement
    output reg [15:0] x_est, // Estimated position
    output reg [15:0] v_est  // Estimated velocity
);
    reg [15:0] x; // Position state
    reg [15:0] v; // Velocity state
    parameter K1 = 16'h0A; // Kalman gain for position
    parameter K2 = 16'h05; // Kalman gain for velocity

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            x <= 16'h0000;
            v <= 16'h0000;
        end else begin
            // Update estimates based on measurements
            x <= x + (K1 * (z1 + z2) / 2 - x);
            v <= v + (K2 * (z1 - x) / 2 - v);
        end
    end

    always @(posedge clk) begin
        x_est <= x;
        v_est <= v;
    end
endmodule