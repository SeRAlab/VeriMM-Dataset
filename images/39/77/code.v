module power_gating(  
    input wire enable,  
    input wire A,  
    input wire B,  
    output wire Y  
);  
    assign Y = (enable) ? (A & B) : 0;  
endmodule