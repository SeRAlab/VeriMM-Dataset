module SR_latch (  
    input S,  
    input R,  
    output reg Q,  
    output reg Q_bar  
);  
    always @ (S or R) begin  
        if (S && !R) begin  
            Q <= 1;  
            Q_bar <= 0;  
        end else if (!S && R) begin  
            Q <= 0;  
            Q_bar <= 1;  
        end  
        // Retain previous state when both S and R are low  
    end  
endmodule