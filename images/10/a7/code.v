module SR_latch(  
    input wire S,  
    input wire R,  
    output reg Q,  
    output reg Qn  
);  
    always @ (S, R) begin  
        if (S && !R) begin  
            Q <= 1;  
            Qn <= 0;  
        end  
        else if (!S && R) begin  
            Q <= 0;  
            Qn <= 1;  
        end  
        // Invalid condition: S=1, R=1
        // Maintain the previous state (no change)
    end  
endmodule