module d_flip_flop (  
    input wire D,  
    input wire CLK,  
    input wire R,  
    output reg Q  
);  
    always @(posedge CLK or posedge R) begin  
        if (R)  
            Q <= 0;  
        else  
            Q <= D;  
    end  
endmodule