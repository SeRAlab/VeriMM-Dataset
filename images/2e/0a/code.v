module SR_latch (  
    input S,  
    input R,  
    output reg Q,  
    output reg Qn  
);  
  
    always @ (S or R) begin  
        if (S && R) begin  
            Q = 1;  
            Qn = 1;  // Invalid state  
        end  
        else if (S && !R) begin  
            Q = 1;  
            Qn = 0;  
        end  
        else if (!S && R) begin  
            Q = 0;  
            Qn = 1;  
        end  
        // when both S and R are low, maintain state
    end  
endmodule