module image_convolution (
    input [8:0] pixel_data, // 3x3 pixels (9 bits)
    input [2:0] filter,     // 3-bit filter
    output reg [7:0] result // 8-bit output pixel
);
    integer i;
    always @(*) begin
        result = 0;
        for (i = 0; i < 9; i = i + 1) begin
            result = result + (pixel_data[i] * filter[i % 3]); // Convolution operation
        end
    end
endmodule