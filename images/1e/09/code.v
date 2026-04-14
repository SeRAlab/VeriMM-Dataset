module PID_Controller (
    input wire clk,
    input wire reset,
    input wire signed [15:0] error,
    input wire signed [15:0] Kp,
    input wire signed [15:0] Ki,
    input wire signed [15:0] Kd,
    output reg signed [31:0] control_output
);
    reg signed [31:0] integral;
    reg signed [15:0] prev_error;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            control_output <= 0;
            integral <= 0;
            prev_error <= 0;
        end else begin
            integral <= integral + error;
            control_output <= (Kp * error) + (Ki * integral) + (Kd * (error - prev_error));
            prev_error <= error;
        end
    end
endmodule