module PID_Controller #(parameter WIDTH = 16, parameter OUT_LIMIT = 255)  
(  
    input clk,  
    input reset,  
    input [WIDTH-1:0] setpoint,  
    input [WIDTH-1:0] process_variable,  
    input [WIDTH-1:0] Kp,  
    input [WIDTH-1:0] Ki,  
    input [WIDTH-1:0] Kd,  
    output reg [WIDTH-1:0] control_output  
);  
    reg [WIDTH-1:0] error;  
    reg [WIDTH-1:0] integral;  
    reg [WIDTH-1:0] derivative;  
    reg [WIDTH-1:0] previous_error;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            control_output <= 0;  
            integral <= 0;  
            previous_error <= 0;  
        end else begin  
            error <= setpoint - process_variable;  
            integral <= integral + error;  
            derivative <= error - previous_error;  
            control_output <= Kp * error + Ki * integral + Kd * derivative;  

            // Output limiting  
            if (control_output > OUT_LIMIT)  
                control_output <= OUT_LIMIT;  
            else if (control_output < 0)  
                control_output <= 0;  

            previous_error <= error;  
        end  
    end  
endmodule