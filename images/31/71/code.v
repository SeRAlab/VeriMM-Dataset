module virtual_memory_management_unit (
    input clk,
    input reset,
    input [7:0] virtual_address,
    input read_enable,
    input write_enable,
    output reg [7:0] physical_address,
    output reg page_fault
);
    reg [7:0] page_table [0:3]; // Simple page table with 4 entries
    reg [1:0] page_index; // 2 bits for page index (0-3)
    
    initial begin
        // Initialize page table with some example mappings
        page_table[0] = 8'h00; // Virtual page 0 -> Physical frame 0
        page_table[1] = 8'h10; // Virtual page 1 -> Physical frame 1
        page_table[2] = 8'h20; // Virtual page 2 -> Physical frame 2
        page_table[3] = 8'h30; // Virtual page 3 -> Physical frame 3
    end
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            physical_address <= 8'b0;
            page_fault <= 1'b0;
        end else begin
            page_index = virtual_address[7:6]; // Get the page index (2 MSBs)
            if (page_index < 4) begin
                physical_address <= {page_table[page_index], virtual_address[5:0]};
                page_fault <= 1'b0; // Valid page
            end else begin
                physical_address <= 8'b0; // Default value
                page_fault <= 1'b1; // Page fault
            end
        end
    end
endmodule