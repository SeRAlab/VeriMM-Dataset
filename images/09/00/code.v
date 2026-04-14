module VirtualMemoryManagement (
    input [3:0] virtual_address,
    output reg [3:0] physical_address,
    output reg page_fault
);
    reg [3:0] page_table [0:3]; // Page table with 4 entries
    initial begin
        // Example page table initialization (1 = present, 0 = not present)
        page_table[0] = 4'b0001; // Page 0 present -> Frame 1
        page_table[1] = 4'b0010; // Page 1 present -> Frame 2
        page_table[2] = 4'b0000; // Page 2 not present
        page_table[3] = 4'b0011; // Page 3 present -> Frame 3
    end

    always @(*) begin
        if (virtual_address < 4 && page_table[virtual_address][3] == 1) begin
            physical_address = page_table[virtual_address][2:0]; // Get frame number
            page_fault = 0; // Page is present
        end else begin
            physical_address = 4'b0000; // Default physical address
            page_fault = 1; // Page fault
        end
    end
endmodule