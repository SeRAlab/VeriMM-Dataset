module dram_cell (  
    input wire D,    // Data input  
    input wire WL,   // Word line (write enable)  
    output reg Q     // Data output  
);  
    always @(posedge WL) begin  
        Q <= D;  // Write data to the cell when WL is high  
    end  
endmodule