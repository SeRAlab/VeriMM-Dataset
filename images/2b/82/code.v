module deadbeat_controller(  
    input [3:0] current_state,  
    input [3:0] desired_state,  
    output reg [3:0] control_action  
);  
    always @(current_state or desired_state) begin  
        control_action = desired_state - current_state;  
    end  
endmodule