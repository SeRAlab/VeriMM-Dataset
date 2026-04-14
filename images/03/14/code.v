module rle_encoder (
    input clk,
    input rst,
    input [7:0] data_in,
    input data_valid,
    output reg [7:0] count_out,
    output reg data_out_valid,
    output reg [7:0] bit_out
);
    reg [7:0] count;
    reg [7:0] current_bit;
    reg encoding_done;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            count <= 0;
            current_bit <= 0;
            count_out <= 0;
            bit_out <= 0;
            data_out_valid <= 0;
            encoding_done <= 0;
        end else if (data_valid) begin
            if (encoding_done) begin
                count <= 1;
                current_bit <= data_in;
                encoding_done <= 0;
                data_out_valid <= 0;
            end else if (data_in == current_bit) begin
                count <= count + 1;
            end else begin
                count_out <= count;
                bit_out <= current_bit;
                data_out_valid <= 1;
                current_bit <= data_in;
                count <= 1;
            end

            if (count == 255) begin
                encoding_done <= 1; // Signal to indicate encoding is complete
            end
        end
    end
endmodule