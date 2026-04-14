module nearest_neighbor_interpolation(  
    input [7:0] pixel_00,  
    input [7:0] pixel_01,  
    input [7:0] pixel_10,  
    input [7:0] pixel_11,  
    output [7:0] pixel_00_out,  
    output [7:0] pixel_01_out,  
    output [7:0] pixel_10_out,  
    output [7:0] pixel_11_out,  
    output [7:0] pixel_20_out,  
    output [7:0] pixel_21_out,  
    output [7:0] pixel_30_out,  
    output [7:0] pixel_31_out  
);  
    // Nearest neighbor mapping  
    assign pixel_00_out = pixel_00;  
    assign pixel_01_out = pixel_01;  
    assign pixel_10_out = pixel_00;  
    assign pixel_11_out = pixel_01;  
    assign pixel_20_out = pixel_10;  
    assign pixel_21_out = pixel_11;  
    assign pixel_30_out = pixel_10;  
    assign pixel_31_out = pixel_11;  
endmodule