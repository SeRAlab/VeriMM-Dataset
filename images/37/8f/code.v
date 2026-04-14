module mpc_controller(  
    input clk,  
    input reset,  
    input [7:0] current_state,  
    input [7:0] setpoint,  
    output reg [7:0] control_signal  
);  
    reg [7:0] error;  
    parameter Kp = 8'd5;  // Proportional gain  
      
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            control_signal <= 8'd0;  
        end else begin  
            error <= setpoint - current_state;  
            control_signal <= control_signal + (Kp * error);  
        end  
    end  
endmodule