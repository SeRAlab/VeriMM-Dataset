module kalman_filter (
    input wire clk,
    input wire reset,
    input wire [15:0] z_measured,  // Measured position
    input wire [15:0] v_prev,      // Previous velocity estimate
    input wire [15:0] x_prev,      // Previous position estimate
    input wire [15:0] dt,          // Time step
    output reg [15:0] x_est,       // Updated position estimate
    output reg [15:0] v_est        // Updated velocity estimate
);

    reg [15:0] q = 16'd1;  // Process noise covariance
    reg [15:0] r = 16'd10; // Measurement noise covariance
    reg [15:0] k;          // Kalman gain

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            x_est <= 16'd0;
            v_est <= 16'd0;
        end else begin
            // Prediction step
            x_est <= x_prev + v_prev * dt;
            v_est <= v_prev; // Assuming constant velocity for simplicity
            
            // Update step
            k <= (x_est - z_measured) * (q / (q + r)); // Kalman gain
            x_est <= x_est + k; // Updated position estimate
            v_est <= v_est; // Keep velocity the same for simplicity
        end
    end
endmodule