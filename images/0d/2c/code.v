module mmu (
    input wire clk,
    input wire reset,
    input wire [3:0] virtual_address,
    output reg [3:0] physical_address,
    output reg error
);
    reg [3:0] page_table [0:15]; // Page table to hold physical addresses
    reg [3:0] virtual_page;

    // Initialize the page table
    initial begin
        page_table[0] = 4'b0001; // Virtual page 0 maps to physical page 1
        page_table[1] = 4'b0010; // Virtual page 1 maps to physical page 2
        page_table[2] = 4'b0011; // Virtual page 2 maps to physical page 3
        page_table[3] = 4'b0100; // Virtual page 3 maps to physical page 4
        // Unmapped pages will default to 0
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            physical_address <= 4'b0000;
            error <= 1'b0;
        end else begin
            virtual_page = virtual_address[3:0];
            if (virtual_page < 4) begin
                physical_address <= page_table[virtual_page];
                error <= 1'b0;
            end else begin
                physical_address <= 4'b0000; // Default value for unmapped addresses
                error <= 1'b1; // Error signal for unmapped address
            end
        end
    end
endmodule