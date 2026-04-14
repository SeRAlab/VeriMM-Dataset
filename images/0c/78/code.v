module nearest_neighbor_interpolation (  
    input [7:0] pixel_a, // top-left pixel  
    input [7:0] pixel_b, // top-right pixel  
    input [7:0] pixel_c, // bottom-left pixel  
    input [7:0] pixel_d, // bottom-right pixel  
    input [1:0] select, // select which pixel to output  
    output reg [7:0] output_pixel  
);  
    always @(*) begin  
        case (select)  
            2'b00: output_pixel = pixel_a; // select top-left  
            2'b01: output_pixel = pixel_b; // select top-right  
            2'b10: output_pixel = pixel_c; // select bottom-left  
            2'b11: output_pixel = pixel_d; // select bottom-right  
            default: output_pixel = 8'b00000000; // default case  
        endcase  
    end  
endmodule