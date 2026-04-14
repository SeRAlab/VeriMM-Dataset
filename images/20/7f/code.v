module MMU (
    input clk,
    input rst,
    input [31:0] v_addr,        // virtual address
    input valid,                // valid bit for translation
    output reg [31:0] p_addr    // physical address
);

    // Page size (4KB)
    localparam PAGE_SIZE = 12; // 4KB = 2^12
    localparam VIRTUAL_PAGE_MASK = 20'hFFFFF; // Virtual page number mask
    localparam PHYSICAL_PAGE_BASE = 32'h00001000; // Physical page base address for page 1

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            p_addr <= 32'b0; // reset physical address
        end else if (valid) begin
            // Get the virtual page number
            if (v_addr[31:12] == 20'b0) begin // Only mapping virtual page 0
                p_addr <= {PHYSICAL_PAGE_BASE[31:12], v_addr[11:0]}; // Map to physical page 1
            end else begin
                p_addr <= 32'b0; // Invalid translation
            end
        end else begin
            p_addr <= 32'b0; // Invalid translation
        end
    end
endmodule