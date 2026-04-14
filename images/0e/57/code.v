module nearest_neighbor_interpolation(  
    input [2:0] x_in,  
    input [2:0] y_in,  
    output reg [4:0] color_out  
);  
    reg [4:0] image[0:7][0:7]; // 8x8 image with 5-bit color values  
   
    initial begin  
        // Initialize the image with some values  
        image[0][0] = 5'b00001;  
        image[0][1] = 5'b00010;  
        image[0][2] = 5'b00011;  
        image[0][3] = 5'b00100;  
        image[0][4] = 5'b00101;  
        image[0][5] = 5'b00110;  
        image[0][6] = 5'b00111;  
        image[0][7] = 5'b01000;  
        // ... (initialize other pixels as needed)  
        image[7][7] = 5'b11111;  
    end  
   
    always @(*) begin  
        // Output the color of the nearest neighbor pixel  
        color_out = image[x_in][y_in];  
    end  
endmodule