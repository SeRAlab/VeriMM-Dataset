module MMU(
    input wire clk,
    input wire reset,
    input wire [9:0] virtual_address,
    input wire [9:0] page_table_base,
    input wire valid,
    output reg [9:0] physical_address,
    output reg page_fault
);
    reg [9:0] page_table [0:3]; // Simple page table with 4 entries
    reg [1:0] page_index;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            physical_address <= 10'b0;
            page_fault <= 1'b0;
        end else if (valid) begin
            page_index = virtual_address[9:8]; // Extracting page index from virtual address
            if (page_index < 4 && page_table[page_index] !== 10'bx) begin // Check if page exists
                physical_address <= page_table[page_index] | virtual_address[7:0]; // Map to physical address
                page_fault <= 1'b0;
            end else begin
                physical_address <= 10'b1111111111; // Error code for page fault
                page_fault <= 1'b1;
            end
        end
    end

    // Initialization of page table for testing
    initial begin
        page_table[0] = 10'b0000000000; // Page 0 -> Physical Address 0
        page_table[1] = 10'b0000000001; // Page 1 -> Physical Address 1
        page_table[2] = 10'b0000000010; // Page 2 -> Physical Address 2
        page_table[3] = 10'b0000000011; // Page 3 -> Physical Address 3
    end
endmodule