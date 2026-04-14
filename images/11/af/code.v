module power_gating(  
    input wire ctrl,  
    input wire req,  
    output wire pwr_en  
);  
    assign pwr_en = ctrl & req;  
endmodule