module virtual_memory_management (
    input clk,
    input [1:0] virtual_page,  // 2-bit virtual page number (0-3)
    input [3:0] write_data,     // 4-bit data to write
    input write_enable,         // Write enable signal
    output reg [3:0] read_data  // Data read from physical memory
);
    // Page table: maps virtual pages to physical frames
    reg [1:0] page_table [0:3]; // 4 entries for page table
    reg [3:0] physical_memory [0:3]; // Physical memory with 4 frames

    initial begin
        // Initialize page table (example mapping)
        page_table[0] = 2'b00; // VP 0 -> PF 0
        page_table[1] = 2'b01; // VP 1 -> PF 1
        page_table[2] = 2'b10; // VP 2 -> PF 2
        page_table[3] = 2'b11; // VP 3 -> PF 3
    end

    always @(posedge clk) begin
        if (write_enable) begin
            // Write data to the mapped physical frame
            physical_memory[page_table[virtual_page]] <= write_data;
        end
        // Read data from the mapped physical frame
        read_data <= physical_memory[page_table[virtual_page]];
    end
endmodule