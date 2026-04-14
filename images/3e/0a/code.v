module sr_latch_nand (  
    input wire S,  
    input wire R,  
    output reg Q,  
    output reg Qn  
);  
    always @(S, R) begin  
        if (S == 1'b0 && R == 1'b1) begin  
            Q <= 1'b1;  
            Qn <= 1'b0;  
        end else if (S == 1'b1 && R == 1'b0) begin  
            Q <= 1'b0;  
            Qn <= 1'b1;  
        end else if (S == 1'b1 && R == 1'b1) begin  
            // Hold state (Q and Qn retain previous values)  
        end else begin  
            // Invalid state for SR latch, can be ignored or handled  
        end  
    end  
endmodule