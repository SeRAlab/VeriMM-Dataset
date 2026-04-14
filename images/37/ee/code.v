module VirtualMemory(
    input clock,
    input [9:0] virtual_address, // 10-bit virtual address
    output reg [9:0] physical_address // 10-bit physical address
);
    reg [9:0] page_table [0:3]; // Simple page table with 4 entries

    initial begin
        page_table[0] = 10'b0000000000; // Mapping for virtual page 0
        page_table[1] = 10'b0000000001; // Mapping for virtual page 1
        page_table[2] = 10'b0000000010; // Mapping for virtual page 2
        page_table[3] = 10'b0000000011; // Mapping for virtual page 3
    end

    always @(posedge clock) begin
        physical_address <= page_table[virtual_address[9:8]]; // Use the upper 2 bits to index the page table
    end
endmodule