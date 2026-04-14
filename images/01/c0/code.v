module PID_Controller (  
    input wire clk,  
    input wire [15:0] setpoint,  
    input wire [15:0] process_variable,  
    output reg [15:0] control_signal  
);  
    reg [15:0] error;  
    reg [15:0] integral;  
    reg [15:0] derivative;  
    reg [15:0] last_error;  

    parameter [15:0] Kp = 16'd2; // Proportional gain  
    parameter [15:0] Ki = 16'd1; // Integral gain  
    parameter [15:0] Kd = 16'd1; // Derivative gain  

    always @(posedge clk) begin  
        error <= setpoint - process_variable;  
        integral <= integral + error;  
        derivative <= error - last_error;  
        control_signal <= (Kp * error) + (Ki * integral) + (Kd * derivative);  
        last_error <= error;  
    end  
endmodule