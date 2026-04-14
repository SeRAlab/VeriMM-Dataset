module non_max_suppression(
    input [7:0] pixel00, input [7:0] pixel01, input [7:0] pixel02,
    input [7:0] pixel10, input [7:0] pixel11, input [7:0] pixel12,
    input [7:0] pixel20, input [7:0] pixel21, input [7:0] pixel22,
    output reg [7:0] output_pixel
);
    always @(*) begin
        if (pixel11 >= pixel00 && pixel11 >= pixel01 && pixel11 >= pixel10 && 
            pixel11 >= pixel12 && pixel11 >= pixel20 && pixel11 >= pixel21) begin
            output_pixel = 255; // Center pixel is maximum
        end else begin
            output_pixel = 0; // Center pixel is not maximum
        end
    end
endmodule