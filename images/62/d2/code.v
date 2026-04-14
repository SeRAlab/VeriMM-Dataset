module top_module(
    input [24:0] input_matrix,
    input [8:0] kernel_matrix,
    output reg [24:0] output_matrix
);reg [2:0] i, j;
reg [24:0] temp_matrix;

always @(*) begin
    for (i = 0; i < 5; i = i + 1) begin
        for (j = 0; j < 5; j = j + 1) begin
            if (i == 0 || i == 4 || j == 0 || j == 4) begin
                temp_matrix[i*5+j] = 0;
            end else begin
                temp_matrix[i*5+j] = input_matrix[(i-1)*5+(j-1)]*kernel_matrix[0] +
                                     input_matrix[(i-1)*5+j]*kernel_matrix[1] +
                                     input_matrix[(i-1)*5+(j+1)]*kernel_matrix[2] +
                                     input_matrix[i*5+(j-1)]*kernel_matrix[3] +
                                     input_matrix[i*5+j]*kernel_matrix[4] +
                                     input_matrix[i*5+(j+1)]*kernel_matrix[5] +
                                     input_matrix[(i+1)*5+(j-1)]*kernel_matrix[6] +
                                     input_matrix[(i+1)*5+j]*kernel_matrix[7] +
                                     input_matrix[(i+1)*5+(j+1)]*kernel_matrix[8];
            end
        end
    end
end

assign output_matrix = temp_matrix;

endmodule