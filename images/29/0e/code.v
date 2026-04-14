module sr_latch (  
    input wire S,  
    input wire R,  
    output reg Q  
);  
    always @ (S, R) begin  
        if (S && ~R)  
            Q <= 1; // Set  
        else if (~S && R)  
            Q <= 0; // Reset  
        // If both S and R are low, retain the state (no change)  
        // If both S and R are high, maintain the previous state (indeterminate)  
    end  
endmodule