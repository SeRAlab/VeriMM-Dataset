module PID_Controller (
    input [31:0] error,
    input clk,
    input reset,
    output reg [31:0] control_signal
);
    parameter Kp = 32'd1; // Proportional constant
    parameter Ki = 32'd1; // Integral constant
    parameter Kd = 32'd1; // Derivative constant

    reg [31:0] integral;
    reg [31:0] previous_error;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            control_signal <= 32'b0;
            integral <= 32'b0;
            previous_error <= 32'b0;
        end else begin
            integral <= integral + error; // Update integral term
            control_signal <= (Kp * error) + (Ki * integral) + (Kd * (error - previous_error)); // Calculate control signal
            previous_error <= error; // Update previous error
        end
    end
endmodule