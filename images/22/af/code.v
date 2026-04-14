module D_latch (  
    input D,  
    input CLK,  
    output reg Q  
);  
    always @(posedge CLK or negedge CLK) begin  
        if (CLK)  
            Q <= D;  
    end  
endmodule