module SR_latch(  
    input S,  
    input R,  
    input clk,  
    output reg Q,  
    output reg Qn  
);  
    always @(posedge clk) begin  
        if (S && !R) begin  
            Q <= 1;  
            Qn <= 0;  
        end  
        else if (!S && R) begin  
            Q <= 0;  
            Qn <= 1;  
        end  
        // If both S and R are high, maintain previous state  
    end  
endmodule