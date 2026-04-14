module PID_Controller (
    input clk,
    input reset,
    input [15:0] error, // 16-bit signed error input
    input [15:0] Kp,    // Proportional gain
    input [15:0] Ki,    // Integral gain
    input [15:0] Kd,    // Derivative gain
    output reg [15:0] control_output // 16-bit signed control output
);

    reg [15:0] integral;
    reg [15:0] prev_error;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            control_output <= 16'b0;
            integral <= 16'b0;
            prev_error <= 16'b0;
        end else begin
            integral <= integral + error;
            control_output <= (Kp * error) + (Ki * integral) + (Kd * (error - prev_error));
            prev_error <= error;
        end
    end
endmodule