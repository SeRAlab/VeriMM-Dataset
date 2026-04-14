module mpc_controller(  
    input wire clk,  
    input wire rst,  
    input wire [15:0] setpoint,  
    input wire [15:0] current_state,  
    input wire [15:0] control_gain,  
    output reg [15:0] control_signal  
);  
    parameter MAX_CONTROL_SIGNAL = 16'hFFFF;  
    parameter MIN_CONTROL_SIGNAL = 16'h0000;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            control_signal <= 16'h0000;  
        end else begin  
            // Calculate the control signal  
            control_signal <= current_state + ((setpoint - current_state) * control_gain) >> 8; // simple proportional control  
            // Clamp the control signal  
            if (control_signal > MAX_CONTROL_SIGNAL)  
                control_signal <= MAX_CONTROL_SIGNAL;  
            else if (control_signal < MIN_CONTROL_SIGNAL)  
                control_signal <= MIN_CONTROL_SIGNAL;  
        end  
    end  
endmodule