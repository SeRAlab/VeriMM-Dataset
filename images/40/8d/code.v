module virtual_memory_management(
    input clk,
    input reset,
    input [3:0] page_id,
    input add_page,
    input remove_page,
    output reg [15:0] page_table,
    output reg page_found
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            page_table <= 16'b0; // Clear page table
            page_found <= 0;
        end else begin
            page_found <= 0; // Reset page_found
            if (add_page) begin
                page_table[page_id] <= 1'b1; // Add page
            end
            if (remove_page) begin
                page_table[page_id] <= 1'b0; // Remove page
            end
            // Check if page_id is in the page table
            if (page_table[page_id]) begin
                page_found <= 1'b1; // Page found
            end
        end
    end
endmodule