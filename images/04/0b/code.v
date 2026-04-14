module d_latch(  
    input D,  
    input CLK,  
    input RST,  
    output reg Q  
);  
    always @(posedge CLK or posedge RST) begin  
        if (RST)  
            Q <= 0;  
        else  
            Q <= D;  
    end  
endmodule