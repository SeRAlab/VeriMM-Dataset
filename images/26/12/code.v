module VirtualMemoryMMU (
    input [3:0] virtual_address,
    input clk,
    output reg [3:0] physical_address
);

    reg [3:0] page_table [0:3]; // 4 entries in the page table
    reg [1:0] virtual_page;

    initial begin
        // Initialize page table with some mappings
        page_table[0] = 4'b0000; // Virtual page 0 -> Physical frame 0
        page_table[1] = 4'b0001; // Virtual page 1 -> Physical frame 1
        page_table[2] = 4'b0010; // Virtual page 2 -> Physical frame 2
        page_table[3] = 4'b0011; // Virtual page 3 -> Physical frame 3
    end

    always @(posedge clk) begin
        virtual_page = virtual_address[3:2]; // Extract the 2-bit virtual page number
        if (virtual_page < 4) begin
            physical_address = page_table[virtual_page]; // Map to physical frame
        end else begin
            physical_address = 4'b1111; // Invalid address
        end
    end
endmodule