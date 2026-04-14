module SR_latch (input S, input R, output reg Q);  
    always @(S or R) begin  
        if (S)  
            Q <= 1;  
        else if (R)  
            Q <= 0;  
    end  
endmodule