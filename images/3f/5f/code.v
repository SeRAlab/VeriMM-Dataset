module PID_Controller(  
    input wire clk,  
    input wire rst,  
    input wire [15:0] setpoint,  
    input wire [15:0] measured_value,  
    output reg [15:0] control_signal  
);  
    parameter Kp = 16'h0001;  // Proportional gain  
    parameter Ki = 16'h0001;  // Integral gain  
    parameter Kd = 16'h0001;  // Derivative gain  

    reg [15:0] error;  
    reg [15:0] prev_error;  
    reg [15:0] integral;  
    reg [15:0] derivative;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            control_signal <= 16'd0;  
            error <= 16'd0;  
            prev_error <= 16'd0;  
            integral <= 16'd0;  
        end else begin  
            error <= setpoint - measured_value;  
            integral <= integral + error;  
            derivative <= error - prev_error;  
            control_signal <= (Kp * error) + (Ki * integral) + (Kd * derivative);  
            prev_error <= error;  
        end  
    end  
endmodule