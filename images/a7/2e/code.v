module top_module(input [15:0] input_matrix, input [8:0] kernel, output reg [3:0] output_conv);reg [3:0] buffer [0:3][0:3];
    integer i, j;
    
    always @(*) begin
        output_conv = 0;
        for (i = 0; i < 2; i = i + 1) begin
            for (j = 0; j < 2; j = j + 1) begin
                buffer[i][j] = input_matrix[i*4+j] * kernel[0] +
                                input_matrix[i*4+j+1] * kernel[1] +
                                input_matrix[(i+1)*4+j] * kernel[2] +
                                input_matrix[(i+1)*4+j+1] * kernel[3] +
                                input_matrix[(i+2)*4+j] * kernel[4] +
                                input_matrix[(i+2)*4+j+1] * kernel[5] +
                                input_matrix[(i*4+j+2)] * kernel[6] +
                                input_matrix[(i*4+j+3)] * kernel[7] +
                                input_matrix[(i+1)*4+j+2] * kernel[8];
            end
        end
        for (i = 0; i < 4; i = i + 1) begin
            for (j = 0; j < 4; j = j + 1) begin
                output_conv[i] = buffer[i][j] + output_conv[i];
            end
        end
    end
endmodule