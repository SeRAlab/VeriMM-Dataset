module virtual_memory_management(
    input clk,
    input rst,
    input [7:0] logical_address,  // 8-bit logical address
    input rw,                     // Read/Write control
    output reg [7:0] physical_address // 8-bit physical address
);

    reg [7:0] page_table [0:3]; // Page table for 4 pages (assuming 2 bits for page number)
    wire [1:0] page_number;
    wire [7:0] offset;

    assign page_number = logical_address[7:6]; // 2 bits for page number
    assign offset = logical_address[5:0];       // 6 bits for offset within page

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // Initialize page table with some values
            page_table[0] <= 8'h00; // Page 0 maps to physical page 0
            page_table[1] <= 8'h01; // Page 1 maps to physical page 1
            page_table[2] <= 8'h02; // Page 2 maps to physical page 2
            page_table[3] <= 8'h03; // Page 3 maps to physical page 3
            physical_address <= 8'h00; // Reset physical address
        end else if (rw) begin
            // On read, convert logical address to physical address
            physical_address <= {page_table[page_number], offset};
        end
    end
endmodule