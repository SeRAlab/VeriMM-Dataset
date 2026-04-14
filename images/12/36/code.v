module dram_cell(  
    input wire D,        // Data input  
    input wire WL,       // Word line for writing  
    input wire SL,       // Sense line for reading  
    output reg Q         // Data output  
);  
    always @(posedge WL) begin  
        Q <= D;          // Write data to the cell  
    end  

    always @(posedge SL) begin  
        // Read data from the cell  
        if (WL == 0) begin  
            // Do nothing, retain the value  
        end  
    end  
endmodule