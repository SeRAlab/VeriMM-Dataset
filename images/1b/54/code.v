module SR_FlipFlop(  
    input wire S,  
    input wire R,  
    input wire clk,  
    output reg Q  
);  
    always @(posedge clk) begin  
        if (S && R)  
            Q <= 1'b0; // Invalid state, defaulting to 0  
        else if (S)  
            Q <= 1'b1;  
        else if (R)  
            Q <= 1'b0;  
        // else Q retains its previous state  
    end  
endmodule