module sr_latch (  
    input S,  
    input R,  
    output reg Q,  
    output reg Qn  
);  
    always @(S or R) begin  
        if (S == 1'b1 && R == 1'b0) begin  
            Q <= 1'b1;  
            Qn <= 1'b0;  
        end  
        else if (S == 1'b0 && R == 1'b1) begin  
            Q <= 1'b0;  
            Qn <= 1'b1;  
        end  
        else if (S == 1'b0 && R == 1'b0) begin  
            Q <= Q;  
            Qn <= Qn;  
        end  
        else begin  
            Q <= 1'bz;  
            Qn <= 1'bz;  
        end  
    end  
endmodule