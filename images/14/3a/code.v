module d_latch(  
    input D,  
    input CLK,  
    output reg Q  
);  
    always @(D or CLK) begin  
        if (CLK)  
            Q <= D;  
    end  
endmodule