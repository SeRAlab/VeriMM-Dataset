module kalman_filter (
    input wire clk,
    input wire reset,
    input wire [15:0] measurement,
    output reg [15:0] position,
    output reg [15:0] velocity
);
    reg [15:0] state [0:1]; // state[0] = position, state[1] = velocity
    reg [15:0] P[0:1][0:1]; // state covariance matrix
    reg [15:0] Q; // process noise covariance
    reg [15:0] R; // measurement noise covariance
    reg [15:0] K; // Kalman gain

    initial begin
        state[0] = 0; // initial position
        state[1] = 0; // initial velocity
        P[0][0] = 1000; P[0][1] = 0; // initial covariance
        P[1][0] = 0; P[1][1] = 1000;
        Q = 1; // process noise
        R = 100; // measurement noise
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state[0] <= 0;
            state[1] <= 0;
        end else begin
            // Prediction step
            state[0] <= state[0] + state[1]; // x' = x + v
            P[0][0] <= P[0][0] + Q; // update covariance

            // Measurement update step
            K <= P[0][0] / (P[0][0] + R); // Kalman gain
            state[0] <= state[0] + K * (measurement - state[0]); // update position
            state[1] <= state[1]; // velocity remains the same
            P[0][0] <= (1 - K) * P[0][0]; // update covariance
            P[0][1] <= (1 - K) * P[0][1];
            P[1][0] <= (1 - K) * P[1][0];
            P[1][1] <= P[1][1] + Q; // update velocity covariance

            position <= state[0];
            velocity <= state[1];
        end
    end
endmodule