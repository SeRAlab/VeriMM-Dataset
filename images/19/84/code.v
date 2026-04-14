module pixel_inverter (
    input [2:0] pixel_input,
    output [2:0] pixel_output
);
    assign pixel_output = ~pixel_input; // Invert the pixel value
endmodule