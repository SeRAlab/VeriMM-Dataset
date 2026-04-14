module SR_Latch (  
    input wire S,  
    input wire R,  
    input wire clk,  
    output reg Q  
);  
    always @(posedge clk) begin  
        if (S && ~R)  
            Q <= 1;  
        else if (~S && R)  
            Q <= 0;  
        // If S = 0 and R = 0, Q keeps its previous state.  
        // If S = 1 and R = 1, it's an invalid state (can be ignored).  
    end  
endmodule