module PID_Controller (
    input wire clk,
    input wire reset,
    input wire [15:0] SP,     // Setpoint
    input wire [15:0] PV,     // Process Variable
    output reg [15:0] CV      // Control Variable
);
    parameter Kp = 16'h000A;  // Proportional Gain
    parameter Ki = 16'h0001;  // Integral Gain
    parameter Kd = 16'h0001;  // Derivative Gain

    reg [15:0] error;          // Error
    reg [15:0] prev_error;     // Previous Error
    reg [31:0] integral;       // Integral term
    reg [15:0] derivative;     // Derivative term

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            CV <= 16'h0000;
            integral <= 32'h00000000;
            prev_error <= 16'h0000;
        end else begin
            error <= SP - PV;  // Calculate the error
            
            // Integral with anti-windup
            integral <= integral + error;
            if (integral > 32'hFFFF) integral <= 32'hFFFF; // Clamp integral

            // Calculate derivative
            derivative <= error - prev_error;
            prev_error <= error; // Update previous error
            
            // PID output
            CV <= (Kp * error) + (Ki * integral[15:0]) + (Kd * derivative);
        end
    end
endmodule