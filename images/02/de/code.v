module PID_Controller (
    input clk,
    input rst,
    input signed [15:0] setpoint,
    input signed [15:0] measured_value,
    input signed [15:0] Kp, // Proportional gain
    input signed [15:0] Ki, // Integral gain
    input signed [15:0] Kd, // Derivative gain
    output reg signed [15:0] control_output
);

    reg signed [15:0] prev_error;
    reg signed [15:0] integral;
    reg signed [15:0] error;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            control_output <= 0;
            prev_error <= 0;
            integral <= 0;
        end else begin
            error <= setpoint - measured_value;
            integral <= integral + error;
            control_output <= Kp * error + Ki * integral + Kd * (error - prev_error);
            prev_error <= error;
        end
    end
endmodule