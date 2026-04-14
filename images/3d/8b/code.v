module mmu (
    input wire clk,
    input wire reset,
    input wire [31:0] virtual_address,
    output reg [31:0] physical_address
);
    reg [31:0] page_table [0:255]; // 256 entries for the page table
    wire [7:0] virtual_page; // 8 bits for virtual page number
    wire [23:0] offset; // 24 bits for offset within the page

    assign virtual_page = virtual_address[31:24];
    assign offset = virtual_address[23:0];

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            physical_address <= 32'b0;
        end else begin
            physical_address <= {page_table[virtual_page], offset};
        end
    end
endmodule