module MMU(
    input clk,
    input reset,
    input [7:0] logical_address,
    input [1:0] access_type, // 00 = read, 01 = write
    output reg [7:0] physical_address,
    output reg status // 0 = success, 1 = page fault
);
    // Page table: 4 entries for simplicity
    reg [7:0] page_table [0:3]; // Maps logical page to physical page
    reg [1:0] page_faults; // To signal page faults
    reg [1:0] logical_page;

    initial begin
        // Initialize page table with some mappings
        page_table[0] = 8'h00; // Logical page 0 maps to physical page 0
        page_table[1] = 8'h01; // Logical page 1 maps to physical page 1
        page_table[2] = 8'hFF; // Logical page 2 maps to a wrong physical page (simulate a fault)
        page_table[3] = 8'h02; // Logical page 3 maps to physical page 2
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            physical_address <= 8'b0;
            status <= 0;
        end else begin
            logical_page = logical_address[7:6]; // Assume 4 pages, use top 2 bits for page number
            if (logical_page < 4) begin
                physical_address <= {page_table[logical_page], logical_address[5:0]}; // Combine page and offset
                status <= 0; // Success
            end else begin
                physical_address <= 8'b0;
                status <= 1; // Page fault
            end
        end
    end
endmodule