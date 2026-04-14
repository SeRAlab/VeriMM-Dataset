module PID_Controller (
    input wire clk,
    input wire reset,
    input wire [15:0] setpoint,
    input wire [15:0] measured,
    output reg [15:0] control_signal
);
    parameter Kp = 16'h0001; // Proportional gain
    parameter Ki = 16'h0001; // Integral gain
    parameter Kd = 16'h0001; // Derivative gain

    reg [15:0] error;
    reg [15:0] prev_error;
    reg [15:0] integral;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            control_signal <= 16'h0000;
            integral <= 16'h0000;
            prev_error <= 16'h0000;
        end else begin
            error <= setpoint - measured;
            integral <= integral + error; // Simple integral
            control_signal <= (Kp * error) + (Ki * integral) + (Kd * (error - prev_error));
            prev_error <= error; // Update previous error
        end
    end
endmodule