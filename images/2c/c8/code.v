module PID_Controller (
    input clk,
    input [15:0] setpoint,
    input [15:0] measured_value,
    output reg [15:0] control_signal
);
    parameter Kp = 16'h0002; // Proportional gain
    parameter Ki = 16'h0001; // Integral gain
    parameter Kd = 16'h0001; // Derivative gain

    reg [15:0] prev_error = 16'h0000;
    reg [15:0] integral = 16'h0000;
    reg [15:0] error;

    always @(posedge clk) begin
        error <= setpoint - measured_value; // Calculate error
        integral <= integral + error; // Update integral term
        control_signal <= (Kp * error) + (Ki * integral) + (Kd * (error - prev_error)); // PID output
        prev_error <= error; // Update previous error
    end
endmodule