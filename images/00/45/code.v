module kalman_filter (
    input wire clk,
    input wire rst,
    input wire [15:0] sensor1,
    input wire [15:0] sensor2,
    input wire [15:0] pred_state,
    input wire [15:0] pred_cov,
    output reg [15:0] updated_state,
    output reg [15:0] updated_cov
);
    reg [15:0] kalman_gain;
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            updated_state <= 16'b0;
            updated_cov <= 16'b0;
        end else begin
            // Simple Kalman filter update equations
            kalman_gain <= pred_cov / (pred_cov + 16'h0010); // Assume measurement noise covariance is 16'h0010
            updated_state <= pred_state + kalman_gain * (sensor1 - pred_state); // Update state with sensor1
            updated_cov <= (16'hFFFF - kalman_gain) * pred_cov; // Update covariance
        end
    end
endmodule