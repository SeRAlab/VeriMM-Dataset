module power_gating_control(  
    input [2:0] control,  
    output power_gate  
);  
    assign power_gate = (control == 3'b000) || (control == 3'b001);  
endmodule