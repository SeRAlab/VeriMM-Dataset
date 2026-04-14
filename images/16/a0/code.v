module D_latch (  
    input wire D,  
    input wire EN,  
    output reg Q  
);  
    always @ (D or EN) begin  
        if (EN)  
            Q <= D;  
    end  
endmodule