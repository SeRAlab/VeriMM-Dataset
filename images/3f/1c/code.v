module PID_Controller #(parameter Kp = 8, Ki = 4, Kd = 2,  
                         MIN_OUTPUT = 0, MAX_OUTPUT = 255)  
                       (input clk,  
                        input rst,  
                        input [7:0] setpoint,  
                        input [7:0] measured_value,  
                        output reg [7:0] control_signal);  

    reg [7:0] error, prev_error;  
    reg [15:0] integral;  
    reg [7:0] derivative;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            control_signal <= 0;  
            integral <= 0;  
            prev_error <= 0;  
        end else begin  
            error <= setpoint - measured_value;  
            integral <= integral + error;  
            derivative <= error - prev_error;  
            prev_error <= error;  
            
            control_signal <= Kp * error + Ki * integral[7:0] + Kd * derivative;  
            
            if (control_signal < MIN_OUTPUT)  
                control_signal <= MIN_OUTPUT;  
            else if (control_signal > MAX_OUTPUT)  
                control_signal <= MAX_OUTPUT;  
        end  
    end  
endmodule