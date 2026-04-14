module VirtualMemoryManagement(
    input wire clk,
    input wire rst,
    input wire [1:0] page_num,   // 2-bit page number (4 pages)
    input wire [3:0] offset,      // 4-bit offset (16 bytes)
    output reg [7:0] physical_addr // 8-bit physical address
);
    // Simple page table mapping
    reg [3:0] page_table [0:3]; // 4 entries with 4 bits each

    initial begin
        // Example page table: 
        // Page 0 -> Frame 1, Page 1 -> Frame 2, Page 2 -> Frame 3, Page 3 -> Frame 0
        page_table[0] = 4'b0001; // Frame 1
        page_table[1] = 4'b0010; // Frame 2
        page_table[2] = 4'b0011; // Frame 3
        page_table[3] = 4'b0000; // Frame 0
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            physical_addr <= 8'b0; // Reset physical address
        end else begin
            // Construct physical address from page number and offset
            physical_addr <= {page_table[page_num], offset}; // Combine frame and offset
        end
    end
endmodule