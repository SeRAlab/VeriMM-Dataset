module D_latch (  
    input wire D,  
    input wire E,  
    output reg Q  
);  
    always @(*) begin  
        if (E)  
            Q = D;  
    end  
endmodule