module sr_latch (  
    input wire S,  
    input wire R,  
    output reg Q  
);  
    always @ (S, R) begin  
        if (S && !R) begin  
            Q <= 1;  // Set  
        end else if (!S && R) begin  
            Q <= 0;  // Reset  
        end  
        // If both S and R are low, retain state  
    end  
endmodule