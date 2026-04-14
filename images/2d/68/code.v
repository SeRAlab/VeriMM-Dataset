module sr_latch(  
    input wire S,  
    input wire R,  
    input wire clk,  
    output reg Q,  
    output reg Qn  
);  
    always @(posedge clk) begin  
        if (S && !R) begin  
            Q <= 1;  
            Qn <= 0;  
        end else if (!S && R) begin  
            Q <= 0;  
            Qn <= 1;  
        end else if (!S && !R) begin  
            // Hold state  
        end else begin  
            // Invalid state (S and R both high)  
            Q <= 1'bx;  
            Qn <= 1'bx;  
        end  
    end  
endmodule