module PID_Controller(  
    input wire clk,  
    input wire reset,  
    input wire [15:0] error,  
    output reg [15:0] control_signal  
);  
    reg [15:0] integral;  
    reg [15:0] previous_error;  
    parameter Kp = 16'h0001; // Proportional gain  
    parameter Ki = 16'h0001; // Integral gain  
    parameter Kd = 16'h0001; // Derivative gain  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            integral <= 16'h0000;  
            previous_error <= 16'h0000;  
            control_signal <= 16'h0000;  
        end else begin  
            integral <= integral + error;  
            control_signal <= (Kp * error) + (Ki * integral) + (Kd * (error - previous_error));  
            previous_error <= error;  
        end  
    end  
endmodule