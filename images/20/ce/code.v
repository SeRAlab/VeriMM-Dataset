module sr_latch (input S, input R, output reg Q, output reg Qn);  
    always @(S or R) begin  
        if (S && R) begin  
            Q <= 1'bx;  // Undefined state  
            Qn <= 1'bx; // Undefined state  
        end  
        else if (S) begin  
            Q <= 1'b1;  
            Qn <= 1'b0;  
        end  
        else if (R) begin  
            Q <= 1'b0;  
            Qn <= 1'b1;  
        end  
    end  
endmodule