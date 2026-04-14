module dram_cell (  
    input wire WL,      // Word line  
    input wire D,       // Data input  
    output reg Q        // Data output  
);  
    always @(posedge WL) begin  
        Q <= D;         // Write data to cell on WL rising edge  
    end  
endmodule