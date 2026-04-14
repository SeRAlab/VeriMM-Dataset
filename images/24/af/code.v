module virtual_memory(
    input wire clk,
    input wire enable,
    input wire [3:0] virtual_address, // 4-bit virtual address
    output reg [3:0] physical_address // 4-bit physical address output
);
    // Page table: 4 entries (virtual page number to physical page number)
    reg [3:0] page_table [0:3]; // 4 entries, 4 bits each

    initial begin
        // Example page mappings
        page_table[0] = 4'b0001; // Virtual page 0 -> Physical page 1
        page_table[1] = 4'b0010; // Virtual page 1 -> Physical page 2
        page_table[2] = 4'b0011; // Virtual page 2 -> Physical page 3
        page_table[3] = 4'b0000; // Virtual page 3 -> Physical page 0 (for 1:1 mapping)
    end

    always @(posedge clk) begin
        if (enable) begin
            physical_address <= page_table[virtual_address];
        end else begin
            physical_address <= 4'b0000; // No translation
        end
    end
endmodule