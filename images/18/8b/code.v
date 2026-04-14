module VirtualMemoryManager(
    input wire clk,
    input wire reset,
    input wire [15:0] virtual_address,
    output reg [15:0] physical_address
);
    parameter PAGE_SIZE = 16'h1000; // 4KB page size
    reg [15:0] page_table [0:15]; // Sample page table with 16 entries

    initial begin
        // Sample mappings for the page table
        page_table[0] = 16'h0000; // Page 0 maps to physical address 0x0000
        page_table[1] = 16'h1000; // Page 1 maps to physical address 0x1000
        page_table[2] = 16'h2000; // Page 2 maps to physical address 0x2000
        page_table[3] = 16'h3000; // Page 3 maps to physical address 0x3000
        page_table[4] = 16'h4000; // Page 4 maps to physical address 0x4000
        page_table[5] = 16'h5000; // Page 5 maps to physical address 0x5000
        page_table[6] = 16'h6000; // Page 6 maps to physical address 0x6000
        page_table[7] = 16'h7000; // Page 7 maps to physical address 0x7000
        page_table[8] = 16'h8000; // Page 8 maps to physical address 0x8000
        page_table[9] = 16'h9000; // Page 9 maps to physical address 0x9000
        page_table[10] = 16'hA000; // Page 10 maps to physical address 0xA000
        page_table[11] = 16'hB000; // Page 11 maps to physical address 0xB000
        page_table[12] = 16'hC000; // Page 12 maps to physical address 0xC000
        page_table[13] = 16'hD000; // Page 13 maps to physical address 0xD000
        page_table[14] = 16'hE000; // Page 14 maps to physical address 0xE000
        page_table[15] = 16'hF000; // Page 15 maps to physical address 0xF000
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            physical_address <= 16'b0;
        end else begin
            physical_address <= page_table[virtual_address[15:12]] + virtual_address[11:0];
        end
    end
endmodule