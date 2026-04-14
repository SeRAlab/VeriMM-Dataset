module mpc_controller (  
    input signed [3:0] current_state,  
    input signed [3:0] setpoint,  
    output reg signed [3:0] control_action  
);  
    always @(*) begin  
        control_action = setpoint - current_state;  
        if (control_action > 7)  
            control_action = 7;  
        else if (control_action < -8)  
            control_action = -8;  
    end  
endmodule