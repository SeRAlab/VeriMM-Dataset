module page_table_translation (
    input clk,
    input [3:0] virtual_page,
    output reg [3:0] physical_frame,
    output reg valid
);

    reg [3:0] page_table [0:15]; // Page table for 16 virtual pages
    initial begin
        // Initializing the page table with some values
        page_table[0] = 4'b0001; // Virtual page 0 maps to physical frame 1
        page_table[1] = 4'b0010; // Virtual page 1 maps to physical frame 2
        page_table[2] = 4'b0011; // Virtual page 2 maps to physical frame 3
        page_table[3] = 4'b0100; // Virtual page 3 maps to physical frame 4
        // Additional entries can be initialized as needed
        // Assume invalid pages map to 4'b1111 (error code)
        page_table[4] = 4'b1111; // Example invalid mapping
        page_table[5] = 4'b1111; // Example invalid mapping
        // ...
        page_table[15] = 4'b1111; // All other pages map to error code
    end

    always @(posedge clk) begin
        if (virtual_page < 4'b0000 || virtual_page > 4'b1111) begin
            valid <= 0;
            physical_frame <= 4'b1111; // Error code
        end else begin
            valid <= 1;
            physical_frame <= page_table[virtual_page];
        end
    end
endmodule