module PID_Controller (  
    input clk,  
    input reset,  
    input [15:0] error,  
    output reg [15:0] control_signal  
);  
    reg [15:0] previous_error;  
    reg [15:0] integral;  
    parameter Kp = 16'h0001; // Proportional gain  
    parameter Ki = 16'h0001; // Integral gain  
    parameter Kd = 16'h0001; // Derivative gain  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            control_signal <= 16'h0000;  
            previous_error <= 16'h0000;  
            integral <= 16'h0000;  
        end else begin  
            integral <= integral + error;  
            control_signal <= (Kp * error) + (Ki * integral) + (Kd * (error - previous_error));  
            previous_error <= error;  
        end  
    end  
endmodule