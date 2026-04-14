module PID_Controller (  
    input wire clk,  
    input wire reset,  
    input wire [15:0] error,  
    input wire [15:0] Kp,  
    input wire [15:0] Ki,  
    input wire [15:0] Kd,  
    output reg [31:0] control_output  
);  
    reg [31:0] integral;  
    reg [15:0] previous_error;  
    reg [31:0] derivative;  
  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            integral <= 0;  
            previous_error <= 0;  
            control_output <= 0;  
        end else begin  
            integral <= integral + error;  
            derivative <= error - previous_error;  
            control_output <= (Kp * error) + (Ki * integral) + (Kd * derivative);  
            previous_error <= error;  
        end  
    end  
endmodule