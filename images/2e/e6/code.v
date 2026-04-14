module dilation(
    input [8:0] img_in, // 3x3 binary image input (flattened)
    output reg [8:0] img_out // 3x3 binary image output (flattened)
);
    always @(*) begin
        img_out[0] = (img_in[0] | img_in[1] | img_in[3]); // Top-left
        img_out[1] = (img_in[0] | img_in[1] | img_in[2] | img_in[3] | img_in[4]); // Top-center
        img_out[2] = (img_in[1] | img_in[2] | img_in[4]); // Top-right
        img_out[3] = (img_in[0] | img_in[3] | img_in[4] | img_in[6]); // Middle-left
        img_out[4] = (img_in[0] | img_in[1] | img_in[2] | img_in[3] | img_in[4] | img_in[5] | img_in[6] | img_in[7]); // Middle-center
        img_out[5] = (img_in[2] | img_in[4] | img_in[5]); // Middle-right
        img_out[6] = (img_in[3] | img_in[6] | img_in[7]); // Bottom-left
        img_out[7] = (img_in[3] | img_in[4] | img_in[6] | img_in[7] | img_in[8]); // Bottom-center
        img_out[8] = (img_in[4] | img_in[5] | img_in[7]); // Bottom-right
    end
endmodule