module pixel_adjustment(  
    input [7:0] pixel_in,  
    input [2:0] adjustment,  
    output [7:0] pixel_out  
);  
    assign pixel_out = (pixel_in + adjustment > 255) ? 8'd255 : (pixel_in + adjustment);  
endmodule