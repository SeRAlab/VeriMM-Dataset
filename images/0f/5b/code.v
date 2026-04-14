module sr_latch(  
    input wire S,  
    input wire R,  
    input wire clk,  
    output reg Q,  
    output reg Q_n  
);  
    always @(posedge clk) begin  
        if (S && !R) begin  
            Q <= 1;  
            Q_n <= 0;  
        end else if (!S && R) begin  
            Q <= 0;  
            Q_n <= 1;  
        end else if (!S && !R) begin  
            Q <= Q;  
            Q_n <= Q_n;  
        end else begin  
            // Invalid state: S and R both high  
            Q <= 1'bx;  
            Q_n <= 1'bx;  
        end  
    end  
endmodule