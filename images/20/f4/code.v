module d_latch(  
    input D,  
    input Enable,  
    output reg Q  
);  
    always @(*) begin  
        if (Enable)  
            Q = D;  
        // Q holds its value when Enable is low  
    end  
endmodule