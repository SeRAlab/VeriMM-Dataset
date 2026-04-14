module deadbeat_controller(input [3:0] current_state,  
                            input [3:0] desired_state,  
                            output reg [3:0] control_output);  

    always @* begin  
        control_output = desired_state - current_state;  
    end  
endmodule