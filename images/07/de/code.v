module VirtualMemoryManagement (
    input wire clk,
    input wire reset,
    input wire [31:0] virtual_address,
    input wire read_write, // 0 for read, 1 for write
    output reg [31:0] physical_address,
    output reg page_fault
);
    reg [31:0] page_table [0:255]; // Page table with 256 entries
    reg [7:0] page_number;
    reg [11:0] offset;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            physical_address <= 32'b0;
            page_fault <= 1'b0;
        end else begin
            page_number = virtual_address[31:20]; // Extract page number
            offset = virtual_address[11:0]; // Extract offset

            if (page_number < 256) begin
                physical_address <= {page_table[page_number][31:12], offset}; // Construct physical address
                page_fault <= 1'b0; // No page fault
            end else begin
                physical_address <= 32'b0; // Default address
                page_fault <= 1'b1; // Page fault
            end
        end
    end
endmodule