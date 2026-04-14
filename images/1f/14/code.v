module kalman_filter(
    input wire clk,
    input wire reset,
    input wire [15:0] measurement, // Noisy measurement
    input wire [15:0] control,      // Control input
    output reg [15:0] estimate      // Filtered estimate
);
    reg [15:0] x;        // State estimate
    reg [15:0] p;        // Estimate covariance
    reg [15:0] q = 16'h0001; // Process noise covariance
    reg [15:0] r = 16'h0010; // Measurement noise covariance
    reg [15:0] k;        // Kalman gain

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            x <= 16'h0000; 
            p <= 16'h0010; // Initial estimate covariance
            estimate <= 16'h0000;
        end else begin
            // Prediction update
            p <= p + q;

            // Kalman gain
            k <= p / (p + r);

            // Measurement update
            x <= x + k * (measurement - x);
            p <= (16'hFFFF - k) * p;

            // Output the estimate
            estimate <= x + control; // Including control input
        end
    end
endmodule