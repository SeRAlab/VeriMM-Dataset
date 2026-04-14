module kalman_filter (
    input clk,
    input rst,
    input [15:0] sensor1,
    input [15:0] sensor2,
    output reg [15:0] estimated_value
);

    reg [15:0] x;     // State estimate
    reg [15:0] p;     // Estimate covariance
    reg [15:0] q;     // Process noise covariance
    reg [15:0] r;     // Measurement noise covariance
    reg [15:0] k;     // Kalman Gain

    initial begin
        x = 16'h0000;  // Initial state estimate
        p = 16'hFFFF;  // Initial covariance
        q = 16'h0001;  // Process noise
        r = 16'h0002;  // Measurement noise
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            x <= 16'h0000;
            p <= 16'hFFFF;
        end else begin
            // Prediction Step
            p <= p + q;

            // Measurement Update Step
            k <= p / (p + r);
            x <= x + k * (sensor1 + sensor2)/2 - x; // Average of sensor1 and sensor2
            p <= (16'hFFFF - k) * p; // Update covariance

            estimated_value <= x; // Output the estimated value
        end
    end
endmodule