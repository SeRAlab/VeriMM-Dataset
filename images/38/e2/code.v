module MMU #(parameter PAGE_SIZE = 1024, parameter NUM_PAGES = 16) (  
    input wire clk,  
    input wire we, // write enable  
    input wire [15:0] virtual_address, // 16-bit virtual address  
    output reg [15:0] physical_address, // 16-bit physical address  
    output reg valid // valid signal  
);  
    // Page table to hold mappings (virtual page to physical page)  
    reg [15:0] page_table [0:NUM_PAGES-1];  
    reg [3:0] virtual_page; // 4 bits for virtual page (16 pages)  
    reg [11:0] offset; // 12 bits for offset within a page (4096 bytes)  
    initial begin  
        // Initialize page table with example mappings  
        page_table[0] = 16'h0001; // VA page 0 maps to PA page 1  
        page_table[1] = 16'h0002; // VA page 1 maps to PA page 2  
        page_table[2] = 16'h0003; // VA page 2 maps to PA page 3  
        page_table[3] = 16'h0004; // VA page 3 maps to PA page 4  
        // Add more mappings as needed  
    end  
    always @(posedge clk) begin  
        virtual_page = virtual_address[15:12]; // Get the virtual page  
        offset = virtual_address[11:0]; // Get the offset  
        if (virtual_page < NUM_PAGES) begin  
            // Valid virtual page  
            physical_address = {page_table[virtual_page][15:12], offset}; // Map to physical address  
            valid = 1;  
        end else begin  
            // Invalid virtual page  
            physical_address = 16'hFFFF; // Indicate error  
            valid = 0;  
        end  
    end  
endmodule