module morphological_dilation #(parameter WIDTH = 5, HEIGHT = 5) (  
    input wire [WIDTH*HEIGHT-1:0] image_in,  
    output wire [WIDTH*HEIGHT-1:0] image_out  
);  
    genvar i, j;  
    generate  
        for (i = 0; i < HEIGHT; i = i + 1) begin: row  
            for (j = 0; j < WIDTH; j = j + 1) begin: col  
                wire pixel_center = image_in[i*WIDTH + j];  
                wire pixel_left   = (j > 0) ? image_in[i*WIDTH + (j-1)] : 0;  
                wire pixel_right  = (j < WIDTH-1) ? image_in[i*WIDTH + (j+1)] : 0;  
                wire pixel_top    = (i > 0) ? image_in[(i-1)*WIDTH + j] : 0;  
                wire pixel_bottom = (i < HEIGHT-1) ? image_in[(i+1)*WIDTH + j] : 0;  
                wire pixel_top_left     = (i > 0 && j > 0) ? image_in[(i-1)*WIDTH + (j-1)] : 0;  
                wire pixel_top_right    = (i > 0 && j < WIDTH-1) ? image_in[(i-1)*WIDTH + (j+1)] : 0;  
                wire pixel_bottom_left   = (i < HEIGHT-1 && j > 0) ? image_in[(i+1)*WIDTH + (j-1)] : 0;  
                wire pixel_bottom_right  = (i < HEIGHT-1 && j < WIDTH-1) ? image_in[(i+1)*WIDTH + (j+1)] : 0;  
                
                assign image_out[i*WIDTH + j] = pixel_center | pixel_left | pixel_right | pixel_top | pixel_bottom | pixel_top_left | pixel_top_right | pixel_bottom_left | pixel_bottom_right;  
            end  
        end  
    endgenerate  
endmodule