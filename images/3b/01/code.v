module PID_Controller (
    input wire clk,
    input wire [7:0] setpoint,
    input wire [7:0] current_value,
    output reg [7:0] control_signal
);
    reg [7:0] prev_error;
    reg [15:0] integral;
    reg [7:0] kp = 8'd2; // Proportional gain
    reg [7:0] ki = 8'd1; // Integral gain
    reg [7:0] kd = 8'd1; // Derivative gain
    reg [7:0] error;

    always @(posedge clk) begin
        error = setpoint - current_value;
        integral = integral + error;
        control_signal = (kp * error) + (ki * integral) + (kd * (error - prev_error));
        prev_error = error;
    end
endmodule