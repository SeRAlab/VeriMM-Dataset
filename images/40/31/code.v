module PID_Controller (
    input wire clk,
    input wire reset,
    input wire [9:0] error,
    output reg [15:0] control_signal
);
    parameter Kp = 16'h0002; // Proportional gain
    parameter Ki = 16'h0001; // Integral gain
    parameter Kd = 16'h0001; // Derivative gain

    reg [15:0] integral;
    reg [9:0] previous_error;
    reg [15:0] derivative;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            control_signal <= 16'b0;
            integral <= 16'b0;
            previous_error <= 10'b0;
        end else begin
            integral <= integral + error; // Accumulate error
            derivative <= error - previous_error; // Calculate derivative
            control_signal <= (Kp * error) + (Ki * integral) + (Kd * derivative); // PID output calculation
            previous_error <= error; // Store current error for next derivative calculation
        end
    end
endmodule