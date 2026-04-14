module mpc_control (  
    input [7:0] current_state,  
    input [7:0] target_state,  
    output [7:0] control_signal  
);  
    assign control_signal = target_state - current_state;  
endmodule