module PID_Controller (
    input wire clk,
    input wire reset,
    input wire [15:0] error,
    input wire [15:0] Kp,   // Proportional gain
    input wire [15:0] Ki,   // Integral gain
    input wire [15:0] Kd,   // Derivative gain
    output reg [31:0] control_signal
);
    reg [31:0] integral;
    reg [15:0] prev_error;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            integral <= 0;
            prev_error <= 0;
            control_signal <= 0;
        end else begin
            integral <= integral + error; // Integral term
            control_signal <= (Kp * error) + (Ki * integral) + (Kd * (error - prev_error)); // PID control signal
            prev_error <= error; // Store previous error
        end
    end
endmodule