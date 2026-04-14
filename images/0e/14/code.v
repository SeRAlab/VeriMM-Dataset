module mpc_control(  
    input signed [7:0] current_state,  
    input signed [7:0] desired_state,  
    output signed [7:0] control_signal  
);  
    assign control_signal = (desired_state - current_state > 10) ? 10 :  
                            (desired_state - current_state < -10) ? -10 :  
                            desired_state - current_state;  
endmodule