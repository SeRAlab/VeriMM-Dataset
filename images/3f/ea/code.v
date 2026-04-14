module flash_memory_cell (  
    input wire WE,     // Write Enable  
    input wire RST,    // Reset  
    input wire data_in, // Data to write  
    output reg data_out // Data read  
);  

always @(posedge WE or posedge RST) begin  
    if (RST) begin  
        data_out <= 0; // Clear the memory cell  
    end else if (WE) begin  
        data_out <= data_in; // Write data to the cell  
    end  
end  
endmodule