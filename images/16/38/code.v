module PID_Controller (
    input clk,
    input reset,
    input [15:0] setpoint,
    input [15:0] process_variable,
    output reg [15:0] control_signal
);
    reg [15:0] error;
    reg [15:0] prev_error;
    reg [15:0] integral;
    wire [15:0] Kp = 16'h000A; // Proportional gain
    wire [15:0] Ki = 16'h0001; // Integral gain
    wire [15:0] Kd = 16'h0002; // Derivative gain

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            control_signal <= 16'h0000;
            prev_error <= 16'h0000;
            integral <= 16'h0000;
        end else begin
            error <= setpoint - process_variable;
            integral <= integral + error;
            control_signal <= (Kp * error) + (Ki * integral) + (Kd * (error - prev_error));
            prev_error <= error;
        end
    end
endmodule