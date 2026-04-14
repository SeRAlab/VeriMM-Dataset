module png_compressor(  
    input [7:0] pixel_value,  
    input [3:0] palette_index,  
    output [11:0] compressed_data  
);  
    assign compressed_data = {pixel_value, palette_index};  
endmodule