module convolution_3x3 (
    input [71:0] matrix, // 3x3 matrix, 8 bits each (total 72 bits)
    input [8:0] kernel,  // 3-bit binary kernel with scaling factor
    output reg [7:0] result // 8-bit output
);
    integer i;
    reg [15:0] sum; // to hold the sum of products
    always @(*) begin
        sum = 0;
        for (i = 0; i < 9; i = i + 1) begin
            sum = sum + (matrix[i * 8 +: 8] * kernel[i]); // multiply and accumulate
        end
        result = sum >> 1; // scale down the result
    end
endmodule