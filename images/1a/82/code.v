module pid_controller(
    input wire clk,
    input wire reset,
    input wire [15:0] error,
    output reg [15:0] control_signal
);
    parameter integer Kp = 2; // Proportional gain
    parameter integer Ki = 1; // Integral gain
    parameter integer Kd = 1; // Derivative gain

    reg [15:0] integral;
    reg [15:0] previous_error;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            control_signal <= 0;
            integral <= 0;
            previous_error <= 0;
        end else begin
            integral <= integral + error;
            control_signal <= (Kp * error) + (Ki * integral) + (Kd * (error - previous_error));
            previous_error <= error;
        end
    end
endmodule