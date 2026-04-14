module SR_Latch(  
    input S,  
    input R,  
    output reg Q,  
    output reg Qn  
);  
    always @(S or R) begin  
        if (S && !R) begin  
            Q <= 1;  
            Qn <= 0;  
        end  
        else if (!S && R) begin  
            Q <= 0;  
            Qn <= 1;  
        end  
        // If S and R are both high, maintain the previous state (invalid state)  
    end  
endmodule