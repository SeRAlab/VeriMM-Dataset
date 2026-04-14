module PID_Controller (
    input clk,
    input rst,
    input [15:0] setpoint,
    input [15:0] process_variable,
    output reg [15:0] control_signal
);
    reg [15:0] previous_error;
    reg [31:0] integral;
    wire [15:0] error;
    wire [15:0] derivative;

    assign error = setpoint - process_variable;
    assign derivative = error - previous_error;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            previous_error <= 16'b0;
            integral <= 32'b0;
            control_signal <= 16'b0;
        end else begin
            integral <= integral + error;
            control_signal <= (error * 16'd2) + (integral[15:0] * 16'd1) + (derivative * 16'd1); // Kp=2, Ki=1, Kd=1
            previous_error <= error;
        end
    end
endmodule