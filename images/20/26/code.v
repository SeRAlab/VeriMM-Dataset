module grayscale_converter (
    input [3:0] pixel_value,
    output [3:0] grayscale_value
);
    assign grayscale_value = pixel_value; // Grayscale is the same as the input in this simplified model
endmodule