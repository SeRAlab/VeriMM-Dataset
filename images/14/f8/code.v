module pid_controller(  
    input clk,  
    input reset,  
    input [15:0] error,  
    output reg [15:0] control_signal  
);  
    parameter Kp = 16'd1;  
    parameter Ki = 16'd1;  
    parameter Kd = 16'd1;  

    reg [15:0] integral;  
    reg [15:0] previous_error;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            control_signal <= 16'b0;  
            integral <= 16'b0;  
            previous_error <= 16'b0;  
        end else begin  
            integral <= integral + error;  
            control_signal <= (Kp * error) + (Ki * integral) + (Kd * (error - previous_error));  
            previous_error <= error;  
        end  
    end  
endmodule