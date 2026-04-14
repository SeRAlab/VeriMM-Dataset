module PID_Controller(  
    input clk,  
    input reset,  
    input [15:0] error,  
    input [15:0] Kp,  
    input [15:0] Ki,  
    input [15:0] Kd,  
    output reg [31:0] control_signal  
);  

    reg [31:0] integral;  
    reg [15:0] previous_error;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            control_signal <= 32'b0;  
            integral <= 32'b0;  
            previous_error <= 16'b0;  
        end else begin  
            integral <= integral + error;  
            control_signal <= (Kp * error) + (Ki * integral) + (Kd * (error - previous_error));  
            previous_error <= error;  
        end  
    end  
endmodule