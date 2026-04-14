module PID_Controller(
    input clk,
    input rst,
    input [15:0] setpoint,
    input [15:0] process_variable,
    input [15:0] Kp, // Proportional gain
    input [15:0] Ki, // Integral gain
    input [15:0] Kd, // Derivative gain
    output reg [15:0] control_output
);
    reg [15:0] error;
    reg [15:0] previous_error;
    reg [31:0] integral;
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            control_output <= 0;
            integral <= 0;
            previous_error <= 0;
        end else begin
            error <= setpoint - process_variable;
            integral <= integral + error;
            control_output <= Kp * error + Ki * integral[15:0] + Kd * (error - previous_error);
            previous_error <= error;
        end
    end
endmodule