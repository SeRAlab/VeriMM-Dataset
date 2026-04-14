module SRAM_Cell(  
    input wire D,  
    input wire WL,  
    output reg Q,  
    output reg BL  
);  
    always @(*) begin  
        if (WL) begin  
            Q <= D;      // Write data to SRAM cell  
        end  
        BL <= Q;          // Output the stored value  
    end  
endmodule