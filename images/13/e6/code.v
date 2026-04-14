module DRAM_Cell (  
    input wire D,  
    input wire WE,  
    output reg Q  
);  
    always @(WE or D) begin  
        if (WE)  
            Q <= D;  
    end  
endmodule