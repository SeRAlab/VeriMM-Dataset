module dram_cell (  
    input wire D,        // Data input  
    input wire WL,       // Word line (write enable)  
    output reg BL        // Bit line (data output)  
);  
    always @ (posedge WL) begin  
        BL <= D;  // Store data when WL is high  
    end  
endmodule