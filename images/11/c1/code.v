module d_latch(  
    input wire D,  
    input wire CLK,  
    output reg Q  
);  
    always @(D or CLK) begin  
        if (CLK)  
            Q <= D;  
    end  
endmodule