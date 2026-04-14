module kalman_filter (
    input clk,
    input reset,
    input [15:0] measurement,
    output reg [15:0] estimate
);
    reg [15:0] state_pred; // Predicted state
    reg [15:0] kalman_gain; // Kalman Gain
    reg [15:0] measurement_noise; // Measurement noise covariance
    reg [15:0] process_noise; // Process noise covariance

    initial begin
        state_pred = 0;
        kalman_gain = 16'h1; // Set constant for simplicity
        measurement_noise = 16'h2; // Set constant for simplicity
        process_noise = 16'h1; // Set constant for simplicity
        estimate = 0;
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            estimate <= 0;
            state_pred <= 0;
        end else begin
            // Prediction step
            state_pred <= estimate;

            // Update step
            estimate <= state_pred + kalman_gain * (measurement - state_pred) / measurement_noise;
        end
    end
endmodule