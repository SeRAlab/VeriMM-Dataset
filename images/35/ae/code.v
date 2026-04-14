module power_gating (  
    input wire in,  
    input wire ctrl1,  
    input wire ctrl2,  
    output wire out  
);  
    assign out = in & ctrl1 & ctrl2;  
endmodule