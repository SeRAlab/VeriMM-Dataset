module PID_Controller (
    input wire clk,
    input wire rst,
    input wire [15:0] error,
    output reg [15:0] control_output
);
    parameter Kp = 16'h0001; // Proportional gain
    parameter Ki = 16'h0001; // Integral gain
    parameter Kd = 16'h0001; // Derivative gain

    reg [15:0] integral;
    reg [15:0] previous_error;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            integral <= 16'h0000;
            previous_error <= 16'h0000;
            control_output <= 16'h0000;
        end else begin
            integral <= integral + error;
            control_output <= (Kp * error) + (Ki * integral) + (Kd * (error - previous_error));
            previous_error <= error;
        end
    end
endmodule