module power_gating(  
    input wire control,  
    output wire power  
);  
    assign power = control;  
endmodule