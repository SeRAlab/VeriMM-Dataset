module VirtualMemoryManagement(
    input wire clk,
    input wire rst,
    input wire [9:0] virtual_addr, // 10-bit virtual address
    output reg [9:0] physical_addr // 10-bit physical address
);
    reg [9:0] page_table [0:3]; // Simple page table with 4 entries

    initial begin
        // Initialize the page table with some mapping
        page_table[0] = 10'b0000000000; // Page 0
        page_table[1] = 10'b0000000001; // Page 1
        page_table[2] = 10'b0000000010; // Page 2
        page_table[3] = 10'b0000000011; // Page 3
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            physical_addr <= 10'b0;
        end else begin
            physical_addr <= page_table[virtual_addr[9:8]]; // Map virtual page to physical page
        end
    end
endmodule