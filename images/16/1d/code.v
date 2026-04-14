module mmu (
    input clk,
    input reset,
    input valid,
    input [15:0] virtual_addr,
    output reg [31:0] physical_addr
);
    // Page table: Each entry maps a 4-bit virtual page number to a 32-bit physical address
    reg [31:0] page_table [0:3];
    reg [3:0] page_num;

    initial begin
        // Initialize the page table with some addresses
        page_table[0] = 32'h00000001; // Virtual Page 0 -> Physical Address 1
        page_table[1] = 32'h00000002; // Virtual Page 1 -> Physical Address 2
        page_table[2] = 32'h00000003; // Virtual Page 2 -> Physical Address 3
        page_table[3] = 32'h00000004; // Virtual Page 3 -> Physical Address 4
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            physical_addr <= 32'h00000000; // Reset output
        end else if (valid) begin
            page_num = virtual_addr[15:12]; // Use the upper 4 bits as the page number
            if (page_num < 4) begin
                physical_addr <= page_table[page_num]; // Translate to physical address
            end else begin
                physical_addr <= 32'hFFFFFFFF; // Error code for invalid page
            end
        end
    end
endmodule