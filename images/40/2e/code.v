module virtual_memory_unit(  
    input clk,  
    input rst,  
    input [31:0] virtual_addr,  
    output reg [31:0] physical_addr,  
    output reg page_fault  
);  
    reg [31:0] page_table [0:3]; // Simple page table with 4 entries  
    reg [1:0] lru_counter [0:3]; // LRU counter for each page table entry  
    reg [1:0] page_index;  
    reg [31:0] current_page;  
    integer i;  
    initial begin  
        // Initialize page table entries as invalid  
        for (i = 0; i < 4; i = i + 1) begin  
            page_table[i] = 32'b0;  
            lru_counter[i] = 2'b00;  
        end  
        page_fault = 1'b0;  
    end  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            physical_addr <= 32'b0;  
            page_fault <= 1'b0;  
        end else begin  
            // Extract page number and offset  
            page_index = virtual_addr[31:30];  
            current_page = page_table[page_index];  

            if (current_page == 32'b0) begin // Page fault case  
                page_fault <= 1'b1;  
                // Simulate loading a page into the page table (simplified)  
                page_table[page_index] <= virtual_addr; // Load current virtual address  
                physical_addr <= virtual_addr; // Map directly for simplicity  
            end else begin  
                page_fault <= 1'b0;  
                physical_addr <= current_page; // Translate to physical address  
            end  

            // Update LRU counters for the page entries  
            for (i = 0; i < 4; i = i + 1) begin  
                if (i == page_index)  
                    lru_counter[i] <= 2'b11; // Most recently used  
                else  
                    lru_counter[i] <= lru_counter[i] - 1; // Decrement LRU  
            end  
        end  
    end  
endmodule