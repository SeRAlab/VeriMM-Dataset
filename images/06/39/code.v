module nearest_neighbor_interpolation(  
    input [1:0] pixel,  
    input [1:0] top,  
    input [1:0] left,  
    input [1:0] right,  
    input [1:0] bottom,  
    output reg [1:0] output_pixel  
);  
    always @(*) begin  
        // Nearest neighbor logic  
        if (top != 2'b00)  
            output_pixel = top;  
        else if (left != 2'b00)  
            output_pixel = left;  
        else if (right != 2'b00)  
            output_pixel = right;  
        else if (bottom != 2'b00)  
            output_pixel = bottom;  
        else  
            output_pixel = pixel;  
    end  
endmodule