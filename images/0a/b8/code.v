module mmu (
    input wire clk,
    input wire rst,
    input wire [7:0] logical_address,
    output reg [7:0] physical_address,
    output reg page_fault
);
    // Page table: 16 entries (4 bits for page number)
    reg [7:0] page_table [0:15]; // Each entry is an 8-bit physical address
    reg [3:0] page_number;
    
    initial begin
        // Initialize the page table with some values (for simulation purposes)
        page_table[0] = 8'h00; // Page 0
        page_table[1] = 8'h01; // Page 1
        page_table[2] = 8'h02; // Page 2
        // ... You can set other pages as needed, or leave them as 0 for page fault.
        page_table[3] = 8'h03; // Page 3
        page_table[4] = 8'h04; // Page 4
        // Assume other pages are not mapped (0 implies invalid)
        page_table[5] = 8'h00; 
        page_table[6] = 8'h00;
        page_table[7] = 8'h00;
        page_table[8] = 8'h00;
        page_table[9] = 8'h00;
        page_table[10] = 8'h00;
        page_table[11] = 8'h00;
        page_table[12] = 8'h00;
        page_table[13] = 8'h00;
        page_table[14] = 8'h00;
        page_table[15] = 8'h00;
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            physical_address <= 8'h00;
            page_fault <= 1'b0;
        end else begin
            page_number = logical_address[7:4]; // Extract page number from logical address
            if (page_table[page_number] != 8'h00) begin // Check if page is valid
                physical_address <= {page_table[page_number], logical_address[3:0]}; // Map to physical address
                page_fault <= 1'b0;
            end else begin
                physical_address <= 8'h00; // Default output
                page_fault <= 1'b1; // Indicate page fault
            end
        end
    end
endmodule