module PID_Controller (
    input clk,
    input reset,
    input signed [15:0] error,
    output reg signed [31:0] control_signal
);
    parameter signed [15:0] Kp = 16'd2;   // Proportional gain
    parameter signed [15:0] Ki = 16'd1;   // Integral gain
    parameter signed [15:0] Kd = 16'd1;   // Derivative gain

    reg signed [15:0] prev_error;
    reg signed [31:0] integral;
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            control_signal <= 32'd0;
            integral <= 32'd0;
            prev_error <= 16'd0;
        end else begin
            integral <= integral + error; // Integral term
            control_signal <= (Kp * error) + (Ki * integral) + (Kd * (error - prev_error)); // PID formula
            prev_error <= error; // Update previous error
        end
    end
endmodule