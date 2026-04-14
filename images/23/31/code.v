module PID_Controller #(parameter WIDTH = 16) (  
    input clk,  
    input rst,  
    input [WIDTH-1:0] error,  
    input [WIDTH-1:0] Kp,  
    input [WIDTH-1:0] Ki,  
    input [WIDTH-1:0] Kd,  
    output reg [WIDTH-1:0] control_signal  
);  
    reg [WIDTH-1:0] integral;  
    reg [WIDTH-1:0] previous_error;  
    reg [WIDTH-1:0] derivative;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            control_signal <= 0;  
            integral <= 0;  
            previous_error <= 0;  
        end else begin  
            integral <= integral + error;  
            derivative <= error - previous_error;  
            control_signal <= (Kp * error) + (Ki * integral) + (Kd * derivative);  
            previous_error <= error;  
        end  
    end  
endmodule