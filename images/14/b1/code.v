module sr_latch(  
    input S,  
    input R,  
    output reg Q  
);  
    always @(S, R) begin  
        if (S && !R) begin  
            Q <= 1; // Set state  
        end else if (!S && R) begin  
            Q <= 0; // Reset state  
        end  
        // Q holds the previous state when both S and R are low  
    end  
endmodule