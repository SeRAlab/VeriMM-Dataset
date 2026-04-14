module flash_memory_cell (  
    input wire D,  
    input wire CLK,  
    input wire WE,  
    output reg Q  
);  
    always @(posedge CLK) begin  
        if (WE) begin  
            Q <= D;  
        end  
    end  
endmodule