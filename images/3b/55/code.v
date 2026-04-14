module convolution_2x2_3x3(
    input [7:0] image00, input [7:0] image01,
    input [7:0] image10, input [7:0] image11,
    input [7:0] kernel00, input [7:0] kernel01, input [7:0] kernel02,
    input [7:0] kernel10, input [7:0] kernel11, input [7:0] kernel12,
    input [7:0] kernel20, input [7:0] kernel21, input [7:0] kernel22,
    output reg [15:0] output_pixel
);
    always @(*) begin
        output_pixel = 
            image00 * kernel00 + image01 * kernel01 + 
            image10 * kernel10 + image11 * kernel11;
    end
endmodule