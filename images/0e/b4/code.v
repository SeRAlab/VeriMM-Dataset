module power_gating_control(  
    input wire enable,  
    input wire control,  
    output wire power_gate  
);  
    assign power_gate = enable & ~control;  
endmodule