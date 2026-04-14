module d_latch(  
    input D,  
    input E,  
    output reg Q  
);  
    always @(D or E) begin  
        if (E)  
            Q <= D;  
    end  
endmodule