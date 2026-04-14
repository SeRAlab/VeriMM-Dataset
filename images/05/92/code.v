module power_gating_controller(  
    input clk,  
    input control,  
    output reg enable  
);  

always @(posedge clk) begin  
    if (control)  
        enable <= 1;  
    else  
        enable <= 0;  
end  
endmodule