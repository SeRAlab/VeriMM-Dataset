module PID_Controller(
    input wire clk,
    input wire [15:0] setpoint,
    input wire [15:0] measured_value,
    input wire [15:0] Kp,
    input wire [15:0] Ki,
    input wire [15:0] Kd,
    output reg [31:0] control_signal
);
    reg [15:0] error;
    reg [31:0] integral;
    reg [15:0] previous_error;
    reg [31:0] derivative;

    always @(posedge clk) begin
        error <= setpoint - measured_value;
        integral <= integral + error;
        derivative <= error - previous_error;

        control_signal <= (Kp * error) + (Ki * integral) + (Kd * derivative);
        previous_error <= error;
    end
endmodule