module VirtualMemoryManagement(
    input clk,
    input reset,
    input [7:0] virtual_address,
    output reg [7:0] physical_address
);
    reg [7:0] page_table [0:3]; // Simple page table with 4 entries

    initial begin
        // Example page table entries
        page_table[0] = 8'b00000000; // Page 0 maps to physical frame 0
        page_table[1] = 8'b00010000; // Page 1 maps to physical frame 1
        page_table[2] = 8'b00100000; // Page 2 maps to physical frame 2
        page_table[3] = 8'b00110000; // Page 3 maps to physical frame 3
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            physical_address <= 8'b00000000; // Reset output
        end else begin
            // Translate virtual address to physical address
            physical_address <= page_table[virtual_address[7:4]] | virtual_address[3:0];
        end
    end
endmodule