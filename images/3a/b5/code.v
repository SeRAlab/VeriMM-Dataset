module SR_latch (input S, input R, output reg Q);  
    always @ (S or R) begin  
        if (S && !R)  
            Q <= 1;  
        else if (!S && R)  
            Q <= 0;  
        // If both S and R are high, maintain the current state (not specified in problem statement)  
    end  
endmodule