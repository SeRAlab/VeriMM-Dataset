module d_flip_flop (  
    input wire D,  
    input wire CLK,  
    input wire RST,  
    input wire EN,  
    output reg Q  
);  
    always @(posedge CLK or posedge RST) begin  
        if (RST)  
            Q <= 1'b0;  
        else if (EN)  
            Q <= D;  
    end  
endmodule