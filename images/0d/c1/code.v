module SR_latch (  
    input wire S,  
    input wire R,  
    input wire clk,  
    output reg Q  
);  
    always @(posedge clk) begin  
        if (S && !R)  
            Q <= 1;  
        else if (!S && R)  
            Q <= 0;  
        else if (!S && !R)  
            Q <= Q;  
        else  
            Q <= 1'bx; // Invalid state  
    end  
endmodule