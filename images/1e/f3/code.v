module kalman_filter (
    input clk,
    input reset,
    input [15:0] measurement1,
    input [15:0] measurement2,
    output reg [15:0] estimate
);
    // Kalman filter parameters
    reg [15:0] x; // estimated state
    reg [15:0] p; // estimation error covariance
    reg [15:0] k; // Kalman gain
    reg [15:0] q; // process noise covariance
    reg [15:0] r; // measurement noise covariance

    initial begin
        x = 16'd0; // initial state
        p = 16'd1; // initial estimation error covariance
        q = 16'd1; // process noise covariance
        r = 16'd1; // measurement noise covariance
        estimate = 16'd0;
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            x <= 16'd0;
            p <= 16'd1;
            estimate <= 16'd0;
        end else begin
            // Prediction update
            p <= p + q;

            // Measurement update
            k <= p / (p + r);
            x <= x + k * (measurement1 + measurement2 - x);
            p <= (16'd1 - k) * p;

            estimate <= x;
        end
    end
endmodule