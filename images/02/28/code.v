module PID_Controller (  
    input wire clk,  
    input wire reset,  
    input wire [15:0] setpoint,  
    input wire [15:0] process_variable,  
    output reg [15:0] control_output  
);  

    reg [15:0] error;  
    reg [15:0] prev_error;  
    reg [15:0] integral;  
    reg [15:0] derivative;  

    parameter Kp = 16'h000A;  // Proportional gain  
    parameter Ki = 16'h0001;  // Integral gain  
    parameter Kd = 16'h0005;  // Derivative gain  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            control_output <= 16'b0;  
            prev_error <= 16'b0;  
            integral <= 16'b0;  
        end else begin  
            error <= setpoint - process_variable;  
            integral <= integral + error;  
            derivative <= error - prev_error;  
            control_output <= (Kp * error) + (Ki * integral) + (Kd * derivative);  
            prev_error <= error;  
        end  
    end  
endmodule