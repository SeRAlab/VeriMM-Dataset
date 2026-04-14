module VirtualMemoryDecoder(  
    input [31:0] virtual_address,  
    output [19:0] page_number,  
    output [11:0] offset  
);  
    assign page_number = virtual_address[31:12]; // Extract upper 20 bits  
    assign offset = virtual_address[11:0];       // Extract lower 12 bits  
endmodule