module PID_Controller(  
    input wire clk,  
    input wire rst,  
    input wire [15:0] setpoint,  
    input wire [15:0] measured_value,  
    input wire [15:0] Kp,  
    input wire [15:0] Ki,  
    input wire [15:0] Kd,  
    output reg [15:0] control_signal  
);  

    reg [15:0] error;  
    reg [15:0] integral;  
    reg [15:0] previous_error;  
    reg [15:0] derivative;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            control_signal <= 16'b0;  
            integral <= 16'b0;  
            previous_error <= 16'b0;  
        end else begin  
            error <= setpoint - measured_value;  
            integral <= integral + error;  
            derivative <= error - previous_error;  
            control_signal <= (Kp * error) + (Ki * integral) + (Kd * derivative);  
            previous_error <= error;  
        end  
    end  
endmodule