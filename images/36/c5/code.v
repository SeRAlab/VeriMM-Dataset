module image_convolution (
    input [8*9-1:0] matrix,  // 3x3 matrix as a concatenated 1D array
    input [2:0] kernel,      // 3-bit kernel
    output reg [7:0] result  // 8-bit result
);
    integer i;
    reg [7:0] temp_result;

    always @(*) begin
        temp_result = 0;
        for (i = 0; i < 9; i = i + 1) begin
            temp_result = temp_result + (matrix[i*8 +: 8] * kernel[i/3]);
        end
        result = temp_result;
    end
endmodule