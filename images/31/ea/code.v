module SRAM_Cell(  
    input wire D,         // Data input  
    input wire WE,       // Write Enable  
    output reg Q         // Output data  
);  
    always @(WE or D) begin  
        if (WE) begin  
            Q <= D;      // Write data to the cell  
        end  
    end  
endmodule