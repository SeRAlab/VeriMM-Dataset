module VirtualMemoryManager (  
    input clk,  
    input reset,  
    input [7:0] virtual_address,  
    input read_write, // 0 for read, 1 for write  
    output reg [7:0] physical_address,  
    output reg page_fault  
);  
    reg [7:0] page_table [0:3]; // Simple page table with 4 entries  
    reg [1:0] current_page;  
    reg [7:0] physical_base_address;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            page_table[0] <= 8'h00;  
            page_table[1] <= 8'h10;  
            page_table[2] <= 8'h20;  
            page_table[3] <= 8'h30;  
            physical_base_address <= 8'h00;  
            page_fault <= 0;  
        end else begin  
            current_page = virtual_address[7:6]; // Use top 2 bits as page index  
            if (current_page < 4) begin  
                physical_address <= page_table[current_page] + virtual_address[5:0];  
                page_fault <= 0;  
            end else begin  
                physical_address <= 8'h00;  
                page_fault <= 1; // Page fault occurs  
            end  
        end  
    end  
endmodule