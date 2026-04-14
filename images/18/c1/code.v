module PID_Controller #(parameter WIDTH=16) (  
    input clk,  
    input rst,  
    input [WIDTH-1:0] setpoint,  
    input [WIDTH-1:0] process_variable,  
    input [WIDTH-1:0] Kp,  
    input [WIDTH-1:0] Ki,  
    input [WIDTH-1:0] Kd,  
    output reg [WIDTH-1:0] control_signal  
);  
    reg [WIDTH-1:0] error;  
    reg [WIDTH-1:0] integral;  
    reg [WIDTH-1:0] derivative;  
    reg [WIDTH-1:0] previous_error;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            control_signal <= 0;  
            integral <= 0;  
            previous_error <= 0;  
        end else begin  
            error <= setpoint - process_variable;  
            integral <= integral + error;  
            derivative <= error - previous_error;  
            control_signal <= (Kp * error + Ki * integral + Kd * derivative) >> 16; // Right shift to prevent overflow  
            previous_error <= error;  
        end  
    end  
endmodule