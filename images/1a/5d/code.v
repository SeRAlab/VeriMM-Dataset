module PID_Controller(
    input wire clk,
    input wire reset,
    input wire [15:0] setpoint,
    input wire [15:0] measured_value,
    output reg [15:0] control_signal
);
    reg [15:0] error;
    reg [15:0] previous_error;
    reg [15:0] integral;
    reg [15:0] derivative;
    reg [15:0] kp = 16'd1; // Proportional gain
    reg [15:0] ki = 16'd1; // Integral gain
    reg [15:0] kd = 16'd1; // Derivative gain

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            control_signal <= 16'd0;
            error <= 16'd0;
            previous_error <= 16'd0;
            integral <= 16'd0;
        end else begin
            error <= setpoint - measured_value;
            integral <= integral + error;
            derivative <= error - previous_error;
            control_signal <= (kp * error) + (ki * integral) + (kd * derivative);
            previous_error <= error;
        end
    end
endmodule