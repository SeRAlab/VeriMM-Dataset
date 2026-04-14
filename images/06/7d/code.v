module dilation (
    input [8:0] image_in, // 3x3 binary image
    output reg [8:0] image_out // 3x3 dilated image
);

always @(*) begin
    image_out[0] = image_in[0] | image_in[1] | image_in[3]; // Top-left
    image_out[1] = image_in[0] | image_in[1] | image_in[2] | image_in[3] | image_in[4]; // Top
    image_out[2] = image_in[1] | image_in[2] | image_in[4]; // Top-right
    image_out[3] = image_in[0] | image_in[3] | image_in[4] | image_in[6]; // Left
    image_out[4] = image_in[0] | image_in[1] | image_in[2] | image_in[3] | image_in[4] | image_in[5] | image_in[6] | image_in[7]; // Center
    image_out[5] = image_in[1] | image_in[2] | image_in[4] | image_in[5] | image_in[8]; // Right
    image_out[6] = image_in[3] | image_in[6] | image_in[7]; // Bottom-left
    image_out[7] = image_in[3] | image_in[4] | image_in[5] | image_in[6] | image_in[7]; // Bottom
    image_out[8] = image_in[4] | image_in[5] | image_in[7]; // Bottom-right
end

endmodule