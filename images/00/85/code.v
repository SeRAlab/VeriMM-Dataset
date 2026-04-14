module SR_Latch (  
    input wire S,  
    input wire R,  
    output reg Q,  
    output reg Qn  
);  
    always @ (S or R) begin  
        if (S && !R) begin  
            Q = 1;  
            Qn = 0;  
        end else if (!S && R) begin  
            Q = 0;  
            Qn = 1;  
        end else if (!S && !R) begin  
            Q = Q;  // Hold state  
            Qn = ~Q;  
        end else begin  
            Q = 1'bx;  // Invalid state  
            Qn = 1'bx;  
        end  
    end  
endmodule