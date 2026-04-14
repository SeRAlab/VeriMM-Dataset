module SR_latch (input S, input R, output reg Q, output Qn);  
    always @(S, R) begin  
        if (S && !R)  
            Q <= 1;  
        else if (!S && R)  
            Q <= 0;  
        // If both S and R are low, retain previous state  
    end  
    assign Qn = ~Q;  
endmodule