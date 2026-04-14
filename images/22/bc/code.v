module mmu (
    input wire clk,
    input wire reset,
    input wire [3:0] virtual_address,
    output reg [1:0] physical_address
);
    
    reg [1:0] page_table [3:0]; // 4 entries for 4-bit virtual address space

    // Initialize the page table with some mappings
    initial begin
        page_table[0] = 2'b00; // Virtual page 0 -> Physical page 0
        page_table[1] = 2'b01; // Virtual page 1 -> Physical page 1
        page_table[2] = 2'b10; // Virtual page 2 -> Physical page 2
        page_table[3] = 2'b11; // Virtual page 3 -> Physical page 3
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            physical_address <= 2'b00; // Default physical address on reset
        end else begin
            physical_address <= page_table[virtual_address[3:2]]; // Translate
        end
    end
endmodule