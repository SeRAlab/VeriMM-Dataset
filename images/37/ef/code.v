module nearest_neighbor_interpolation (  
    input [7:0] pixel_00,  
    input [7:0] pixel_01,  
    input [7:0] pixel_10,  
    input [7:0] pixel_11,  
    output reg [7:0] pixel_00_out,  
    output reg [7:0] pixel_01_out,  
    output reg [7:0] pixel_10_out,  
    output reg [7:0] pixel_11_out,  
    output reg [7:0] pixel_20_out,  
    output reg [7:0] pixel_21_out,  
    output reg [7:0] pixel_30_out,  
    output reg [7:0] pixel_31_out  
);  
    always @(*) begin  
        pixel_00_out = pixel_00;  
        pixel_01_out = pixel_01;  
        pixel_10_out = pixel_10;  
        pixel_11_out = pixel_11;  
        pixel_20_out = pixel_00;  
        pixel_21_out = pixel_01;  
        pixel_30_out = pixel_10;  
        pixel_31_out = pixel_11;  
    end  
endmodule