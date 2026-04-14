module PID_Controller (
    input clk,
    input reset,
    input [15:0] error,
    output reg [15:0] control_signal
);
    parameter Kp = 16'h000A;  // Proportional gain
    parameter Ki = 16'h0001;  // Integral gain
    parameter Kd = 16'h0005;  // Derivative gain

    reg [15:0] integral;
    reg [15:0] last_error;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            control_signal <= 16'h0000;
            integral <= 16'h0000;
            last_error <= 16'h0000;
        end else begin
            integral <= integral + error; // Accumulate integral
            control_signal <= (Kp * error) + (Ki * integral) + (Kd * (error - last_error)); // PID formula
            last_error <= error; // Update last error
        end
    end
endmodule