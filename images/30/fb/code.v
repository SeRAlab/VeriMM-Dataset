module virtual_memory_management (
    input wire clk,
    input wire reset,
    input wire [1:0] vpage, // 2-bit virtual page number
    input wire [3:0] offset, // 4-bit offset within the page
    input wire valid_in, // valid bit input
    output reg [3:0] pframe, // 4-bit physical frame number
    output reg valid_out // valid bit output
);
    reg [3:0] page_table [3:0]; // 4 entries for the page table
    reg valid_bits [3:0]; // 4 valid bits

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Initialize page table and valid bits
            page_table[0] <= 4'b0000; valid_bits[0] <= 1'b0;
            page_table[1] <= 4'b0001; valid_bits[1] <= 1'b0;
            page_table[2] <= 4'b0010; valid_bits[2] <= 1'b0;
            page_table[3] <= 4'b0011; valid_bits[3] <= 1'b0;
        end else begin
            // Update page table on valid_in
            if (valid_in) begin
                page_table[vpage] <= vpage; // Simple mapping of vpage to pframe
                valid_bits[vpage] <= 1'b1; // Mark this page as valid
            end
            // Output corresponding physical frame and valid bit
            pframe <= valid_bits[vpage] ? page_table[vpage] : 4'bxxxx; // Output physical frame if valid
            valid_out <= valid_bits[vpage]; // Output valid bit
        end
    end
endmodule