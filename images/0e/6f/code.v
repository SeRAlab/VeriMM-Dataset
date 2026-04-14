module power_gating_control(  
    input wire en,  
    input wire ps,  
    output wire gated_power  
);  
    assign gated_power = en & ~ps;  
endmodule