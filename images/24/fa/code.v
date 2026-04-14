module VirtualMemoryManager (
    input clk,
    input rst,
    input [1:0] vpage,        // Virtual page (2 bits for 4 pages)
    input [1:0] pframe_in,    // Physical frame input (to be written)
    input write_enable,        // Write enable
    output reg [1:0] pframe_out // Physical frame output (read from page table)
);

    reg [1:0] page_table [0:3]; // Page table with 4 entries

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // Reset the page table
            page_table[0] <= 2'b00;
            page_table[1] <= 2'b00;
            page_table[2] <= 2'b00;
            page_table[3] <= 2'b00;
        end else begin
            if (write_enable) begin
                // Write operation to page table
                page_table[vpage] <= pframe_in;
            end
            // Read operation from page table
            pframe_out <= page_table[vpage];
        end
    end
endmodule