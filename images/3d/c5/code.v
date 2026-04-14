module sr_latch(  
    input S,  
    input R,  
    output reg Q  
);  
    always @ (S or R) begin  
        if (S && R)  
            ; // Invalid state, do nothing  
        else if (S)  
            Q = 1; // Set  
        else if (R)  
            Q = 0; // Reset  
    end  
endmodule