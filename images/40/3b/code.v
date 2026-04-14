module power_gating(  
    input wire enable,  
    input wire power_gating_control,  
    output wire power_state  
);  
    assign power_state = enable ? power_gating_control : 1'b0;  
endmodule