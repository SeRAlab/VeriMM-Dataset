module MMU (
    input clk,
    input rst,
    input [7:0] virtual_addr,
    output reg [7:0] physical_addr,
    output reg page_fault
);
    reg [7:0] page_table [0:15]; // Page table with 16 entries, 8-bit physical addresses
    reg [3:0] page_index;
    
    // Initial page table with some mappings
    initial begin
        page_table[0] = 8'h00; // Page 0
        page_table[1] = 8'h01; // Page 1
        page_table[2] = 8'h02; // Page 2
        page_table[3] = 8'h03; // Page 3
        page_table[4] = 8'h04; // Page 4
        page_table[5] = 8'h05; // Page 5
        page_table[6] = 8'h06; // Page 6
        page_table[7] = 8'h07; // Page 7
        page_table[8] = 8'hFF; // Page 8 (not present)
        page_table[9] = 8'h09; // Page 9
        page_table[10] = 8'h0A; // Page 10
        page_table[11] = 8'h0B; // Page 11
        page_table[12] = 8'h0C; // Page 12
        page_table[13] = 8'h0D; // Page 13
        page_table[14] = 8'h0E; // Page 14
        page_table[15] = 8'h0F; // Page 15
    end
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            physical_addr <= 8'h00;
            page_fault <= 1'b0;
        end else begin
            page_index = virtual_addr[3:0]; // Using lower 4 bits as page index
            if (page_table[page_index] == 8'hFF) begin
                page_fault <= 1'b1; // Page fault
                physical_addr <= 8'hFF; // Fault address
            end else begin
                page_fault <= 1'b0;
                physical_addr <= page_table[page_index]; // Translate to physical address
            end
        end
    end
endmodule