module kalman_filter (
    input clk,
    input reset,
    input [15:0] z,         // Measurement input (sensor reading)
    input [15:0] q,         // Process noise covariance
    input [15:0] r,         // Measurement noise covariance
    output reg [15:0] x_hat, // Estimated position
    output reg [15:0] v_hat  // Estimated velocity
);
    reg [15:0] p;           // Estimation error covariance
    reg [15:0] k;           // Kalman gain

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            x_hat <= 0;
            v_hat <= 0;
            p <= 0;
        end else begin
            // Prediction Step
            p <= p + q;
            // Update Step
            k <= p / (p + r);
            x_hat <= x_hat + k * (z - x_hat);
            v_hat <= v_hat; // Assuming constant velocity for simplicity
            p <= (1 - k) * p;
        end
    end
endmodule