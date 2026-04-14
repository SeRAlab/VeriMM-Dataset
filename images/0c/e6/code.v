module PID_Controller(
    input wire clk,
    input wire rst,
    input wire signed [15:0] error,
    output reg signed [15:0] control_signal
);
    parameter signed [15:0] Kp = 16'd2;
    parameter signed [15:0] Ki = 16'd1;
    parameter signed [15:0] Kd = 16'd1;

    reg signed [15:0] prev_error;
    reg signed [15:0] integral;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            control_signal <= 16'd0;
            prev_error <= 16'd0;
            integral <= 16'd0;
        end else begin
            integral <= integral + error; // Accumulate integral
            control_signal <= (Kp * error) + (Ki * integral) + (Kd * (error - prev_error)); // PID formula
            prev_error <= error; // Update previous error
        end
    end
endmodule