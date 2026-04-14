module flash_memory_cell (  
    input wire D,  
    input wire C,  
    output reg Q  
);  
    always @(*) begin  
        if (C)  
            Q = D;  
    end  
endmodule