module PID_Controller(  
    input clk,  
    input reset,  
    input signed [7:0] error,  
    input signed [7:0] Kp,  
    input signed [7:0] Ki,  
    input signed [7:0] Kd,  
    output reg signed [7:0] control_output  
);  

    reg signed [7:0] integral;  
    reg signed [7:0] previous_error;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
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