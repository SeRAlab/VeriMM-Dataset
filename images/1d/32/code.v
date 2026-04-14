module PID_Controller #(parameter N = 8) (  
    input clk,  
    input rst,  
    input signed [N-1:0] error,  
    input signed [N-1:0] Kp,  
    input signed [N-1:0] Ki,  
    input signed [N-1:0] Kd,  
    output reg signed [N-1:0] control_output  
);  
    reg signed [N-1:0] integral;  
    reg signed [N-1:0] previous_error;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            control_output <= 0;  
            integral <= 0;  
            previous_error <= 0;  
        end else begin  
            integral <= integral + error;  
            control_output <= (Kp * error) + (Ki * integral) + (Kd * (error - previous_error));  
            previous_error <= error;  
        end  
    end  
endmodule