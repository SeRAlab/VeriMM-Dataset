module page_translation (
    input wire clk,
    input wire rst,
    input wire [1:0] virtual_page,
    output reg [1:0] physical_frame
);
    
    reg [1:0] page_table [0:3]; // 4 entries in the page table

    initial begin
        page_table[0] = 2'b00; // Virtual page 0 maps to Physical frame 0
        page_table[1] = 2'b01; // Virtual page 1 maps to Physical frame 1
        page_table[2] = 2'b10; // Virtual page 2 maps to Physical frame 2
        page_table[3] = 2'b11; // Virtual page 3 maps to Physical frame 3
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            physical_frame <= 2'b00; // Reset output
        end else begin
            if (virtual_page < 2'b00 || virtual_page > 2'b11) 
                physical_frame <= 2'b00; // Invalid page number
            else 
                physical_frame <= page_table[virtual_page]; // Translate
        end
    end
endmodule