module PID_Controller #(  
    parameter Kp = 8'h01,  
    parameter Ki = 8'h01,  
    parameter Kd = 8'h01  
) (  
    input clk,  
    input reset,  
    input signed [15:0] error,  
    output reg signed [31:0] control_signal  
);  
    reg signed [15:0] prev_error;  
    reg signed [31:0] integral;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            control_signal <= 0;  
            integral <= 0;  
            prev_error <= 0;  
        end else begin  
            integral <= integral + error;  
            control_signal <= (Kp * error) + (Ki * integral) + (Kd * (error - prev_error));  
            prev_error <= error;  
        end  
    end  
endmodule