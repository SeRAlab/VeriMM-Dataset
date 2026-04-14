module virtual_memory_translation (
    input [15:0] virtual_address,
    output [9:0] physical_page_number,
    output [5:0] offset
);
    assign physical_page_number = virtual_address[15:6]; // Upper 10 bits
    assign offset = virtual_address[5:0]; // Lower 6 bits
endmodule