module rle_encoder(
    input clk,
    input rst,
    input [4:0] data_in,
    output reg [15:0] encoded_out,
    output reg valid
);
    reg [2:0] count;
    reg current_bit;
    integer i;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            encoded_out <= 0;
            valid <= 0;
            count <= 0;
            current_bit <= 0;
        end else begin
            count = 1;
            encoded_out = 0;
            valid <= 1;

            for (i = 0; i < 5; i = i + 1) begin
                if (i == 0) begin
                    current_bit = data_in[i];
                end else if (data_in[i] == current_bit) begin
                    count = count + 1;
                end else begin
                    encoded_out = {encoded_out, count, current_bit}; // Append count and bit
                    current_bit = data_in[i];
                    count = 1; // Reset count
                end
            end
            encoded_out = {encoded_out, count, current_bit}; // Append the last run
        end
    end
endmodule