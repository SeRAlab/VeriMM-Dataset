module SR_latch(input S, input R, output reg Q, output reg Qn);  
    always @(S or R) begin  
        if (S && R) begin  
            // Invalid state, do nothing or maintain previous state  
        end else if (S) begin  
            Q <= 1;  
            Qn <= 0;  
        end else if (R) begin  
            Q <= 0;  
            Qn <= 1;  
        end  
    end  
endmodule