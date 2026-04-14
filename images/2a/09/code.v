module deadbeat_controller (  
    input clk,  
    input rst,  
    input signed [15:0] error,  
    input signed [15:0] previous_error,  
    output reg signed [15:0] control_signal  
);  
    parameter signed Kp = 16'h0001; // Proportional gain  
    parameter signed Ki = 16'h0001; // Integral gain  

    always @(posedge clk or posedge rst) begin  
        if (rst)  
            control_signal <= 16'h0000;  
        else  
            control_signal <= (Kp * error) + (Ki * previous_error);  
    end  
endmodule