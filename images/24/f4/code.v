module rle_compressor (  
    input [7:0] pixel_in,  
    output reg [3:0] count_out,  
    output reg [3:0] pixel_out  
);  
    reg [7:0] last_pixel;  
    always @(*) begin  
        if (pixel_in == last_pixel) begin  
            count_out = count_out + 1;  
        end else begin  
            count_out = 1;  
            pixel_out = pixel_in[3:0];  
        end  
        last_pixel = pixel_in;  
    end  
endmodule