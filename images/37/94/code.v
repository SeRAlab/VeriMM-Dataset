module rgb_to_grayscale(  
    input [7:0] rgb_pixel,  
    output [3:0] grayscale  
);  
    wire [2:0] red = rgb_pixel[7:5];  
    wire [2:0] green = rgb_pixel[4:2];  
    wire [1:0] blue = rgb_pixel[1:0];  
  
    assign grayscale = (red + green + (blue >> 1)); // Average for grayscale  
  
endmodule