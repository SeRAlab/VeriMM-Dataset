module PID_Controller (
    input clk,
    input rst,
    input [9:0] error,
    input [15:0] Kp,
    input [15:0] Ki,
    input [15:0] Kd,
    output reg [15:0] control_signal
);
    reg [15:0] integral_error;
    reg [9:0] previous_error;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            control_signal <= 16'b0;
            integral_error <= 16'b0;
            previous_error <= 10'b0;
        end else begin
            integral_error <= integral_error + error;
            control_signal <= (Kp * error) + (Ki * integral_error) + (Kd * (error - previous_error));
            previous_error <= error;
        end
    end
endmodule