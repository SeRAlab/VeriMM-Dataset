module vmu(  
    input [31:0] virtual_address,  
    output reg [31:0] physical_address  
);  
    reg [31:0] page_table [0:1]; // Simple page table with 2 entries  
    reg [31:0] page_size = 32'h00000FFF; // 4 KB page size  

    always @(virtual_address) begin  
        // Simplified page table mapping  
        if (virtual_address[31:12] == 0)  
            physical_address = (virtual_address & page_size) | page_table[0];  
        else if (virtual_address[31:12] == 1)  
            physical_address = (virtual_address & page_size) | page_table[1];  
        else  
            physical_address = 32'hFFFFFFFF; // Invalid address  
    end  
endmodule