module PID_Controller(
    input wire clk,
    input wire reset,
    input wire signed [15:0] error,
    output reg signed [15:0] control_signal
);
    parameter signed [15:0] Kp = 16'h0002; // Proportional gain
    parameter signed [15:0] Ki = 16'h0001; // Integral gain
    parameter signed [15:0] Kd = 16'h0001; // Derivative gain

    reg signed [15:0] integral;
    reg signed [15:0] previous_error;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            integral <= 16'h0000;
            previous_error <= 16'h0000;
            control_signal <= 16'h0000;
        end else begin
            integral <= integral + error; // Update integral
            control_signal <= (Kp * error) + (Ki * integral) + (Kd * (error - previous_error)); // PID calculation
            previous_error <= error; // Update previous error
        end
    end
endmodule