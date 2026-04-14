module SR_FF (  
    input wire S,  
    input wire R,  
    input wire clk,  
    output reg Q  
);  
    always @(posedge clk) begin  
        if (S && R)  
            Q <= 1'bx; // invalid state  
        else if (S)  
            Q <= 1;  
        else if (R)  
            Q <= 0;  
    end  
endmodule