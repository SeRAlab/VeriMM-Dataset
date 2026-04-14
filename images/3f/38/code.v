module D_latch (  
    input wire D,  
    input wire enable,  
    output reg Q  
);  
    always @ (D or enable) begin  
        if (enable)  
            Q <= D;  
    end  
endmodule