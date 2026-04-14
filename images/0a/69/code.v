module PID_Controller (
    input clk,
    input reset,
    input [15:0] setpoint,
    input [15:0] process_variable,
    input [15:0] Kp,
    input [15:0] Ki,
    input [15:0] Kd,
    output reg [31:0] control_signal
);
    reg [15:0] error;
    reg [31:0] integral;
    reg [15:0] prev_error;
    reg [31:0] derivative;
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            control_signal <= 0;
            integral <= 0;
            prev_error <= 0;
        end else begin
            error <= setpoint - process_variable;
            integral <= integral + error;
            derivative <= error - prev_error;
            control_signal <= (Kp * error) + (Ki * integral) + (Kd * derivative);
            prev_error <= error;
        end
    end
endmodule