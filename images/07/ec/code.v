module VirtualMemoryManagement(
    input wire clk,
    input wire reset,
    input wire [7:0] virtual_address,
    output reg [7:0] physical_address
);
    // Define a simple page table with 4 entries (2-bit page number)
    reg [7:0] page_table [3:0];

    initial begin
        // Initialize the page table (virtual page number to physical page number mapping)
        page_table[0] = 8'h00; // Virtual page 0 maps to Physical page 0
        page_table[1] = 8'h10; // Virtual page 1 maps to Physical page 1
        page_table[2] = 8'h20; // Virtual page 2 maps to Physical page 2
        page_table[3] = 8'h30; // Virtual page 3 maps to Physical page 3
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            physical_address <= 8'h00;
        end else begin
            // Extract the page number from the virtual address
            // Assume the upper 2 bits represent the page number
            // Assume the lower 6 bits represent the offset within the page
            physical_address <= {page_table[virtual_address[7:6]], virtual_address[5:0]};
        end
    end
endmodule