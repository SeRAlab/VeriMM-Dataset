module KalmanFilter (
    input wire clk,
    input wire rst,
    input wire [15:0] measurement,
    input wire [15:0] estimate,
    output reg [15:0] updated_estimate
);
    parameter PROCESS_NOISE = 16'd5;
    parameter MEASUREMENT_NOISE = 16'd10;
    parameter KALMAN_GAIN = 16'd2; // Simplified constant Kalman gain

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            updated_estimate <= 16'd0;
        end else begin
            updated_estimate <= estimate + KALMAN_GAIN * (measurement - estimate) / (PROCESS_NOISE + MEASUREMENT_NOISE);
        end
    end
endmodule