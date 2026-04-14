module PID_Controller (
    input wire clk,
    input wire rst,
    input wire signed [15:0] error, // Input error signal
    output reg signed [31:0] control_signal // Output control signal
);
    reg signed [31:0] integral;
    reg signed [15:0] previous_error;
    parameter signed [15:0] Kp = 16'd2; // Proportional gain
    parameter signed [15:0] Ki = 16'd1; // Integral gain
    parameter signed [15:0] Kd = 16'd1; // Derivative gain

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            control_signal <= 32'd0;
            integral <= 32'd0;
            previous_error <= 16'd0;
        end else begin
            // Proportional
            control_signal <= Kp * error;

            // Integral
            integral <= integral + error;
            control_signal <= control_signal + (Ki * integral);

            // Derivative
            control_signal <= control_signal + (Kd * (error - previous_error));
            
            previous_error <= error;
        end
    end
endmodule