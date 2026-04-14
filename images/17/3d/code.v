module power_gating_controller(  
    input wire enable,  
    input wire power_state,  
    output wire power_status  
);  
    assign power_status = enable & power_state;  
endmodule