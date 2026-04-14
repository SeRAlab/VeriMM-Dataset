module PID_Controller (
    input clk,
    input reset,
    input [7:0] setpoint,
    input [7:0] measured_value,
    input [7:0] Kp, // Proportional gain
    input [7:0] Ki, // Integral gain
    input [7:0] Kd, // Derivative gain
    output reg [15:0] pid_output
);
    reg [7:0] error;
    reg [15:0] integral;
    reg [7:0] previous_error;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            pid_output <= 16'b0;
            integral <= 16'b0;
            previous_error <= 8'b0;
        end else begin
            error <= setpoint - measured_value;
            integral <= integral + error; // Simple integral accumulation
            pid_output <= Kp * error + Ki * integral + Kd * (error - previous_error);
            previous_error <= error;
        end
    end
endmodule