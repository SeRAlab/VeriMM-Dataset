module dwt_2d (
    input clk,
    input rst,
    input valid,
    input [63:0] data_in, // 8x8 input matrix flattened
    output reg [63:0] data_out,
    output reg done
);
    reg [63:0] temp_data;
    integer i, j;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            data_out <= 0;
            done <= 0;
            temp_data <= 0;
        end else if (valid) begin
            temp_data <= data_in;
            // Perform Haar wavelet transform here, simplified for brevity
            for (i = 0; i < 8; i = i + 1) begin
                for (j = 0; j < 4; j = j + 1) begin
                    data_out[i*8+j] <= (temp_data[i*8+j*2] + temp_data[i*8+j*2+1]) >> 1; // Average
                    data_out[i*8+j+4] <= (temp_data[i*8+j*2] - temp_data[i*8+j*2+1]) >> 1; // Difference
                end
            end
            done <= 1;
        end
    end
endmodule