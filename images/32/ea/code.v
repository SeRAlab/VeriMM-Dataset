module virtual_memory_decoder (
    input [15:0] virtual_address,
    output [3:0] page_number,
    output [11:0] offset
);
    assign page_number = virtual_address[15:12]; // Extracting the 4 most significant bits for page number
    assign offset = virtual_address[11:0];       // Extracting the 12 least significant bits for offset
endmodule