module mmu (
    input clk,
    input reset,
    input [15:0] virtual_address,
    output reg [15:0] physical_address
);
    reg [3:0] page_table [0:15]; // Page table with 16 entries (4 bits each)
    reg [3:0] page_number;
    reg [3:0] offset;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            physical_address <= 16'b0;
        end else begin
            page_number = virtual_address[15:12]; // Get page number (4 bits)
            offset = virtual_address[11:0]; // Get offset (12 bits)
            physical_address <= {page_table[page_number], offset}; // Map to physical address
        end
    end

    // Initializing the page table with some example mappings
    initial begin
        page_table[0] = 4'b0000;
        page_table[1] = 4'b0001;
        page_table[2] = 4'b0010;
        page_table[3] = 4'b0011;
        page_table[4] = 4'b0100;
        page_table[5] = 4'b0101;
        page_table[6] = 4'b0110;
        page_table[7] = 4'b0111;
        page_table[8] = 4'b1000;
        page_table[9] = 4'b1001;
        page_table[10] = 4'b1010;
        page_table[11] = 4'b1011;
        page_table[12] = 4'b1100;
        page_table[13] = 4'b1101;
        page_table[14] = 4'b1110;
        page_table[15] = 4'b1111;
    end
endmodule