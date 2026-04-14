module rle_encoder (
    input [7:0] data_in,
    output reg [15:0] rle_out
);
    integer i;
    reg [7:0] count;
    reg current_bit;

    always @(*) begin
        rle_out = 16'b0; // Initialize output
        count = 0;
        current_bit = data_in[0];

        for (i = 0; i < 8; i = i + 1) begin
            if (data_in[i] == current_bit) begin
                count = count + 1;
            end else begin
                // Concatenate count and current_bit to rle_out
                rle_out = {count, current_bit} | rle_out;
                current_bit = data_in[i];
                count = 1;
            end
        end

        // Handle the last group
        rle_out = {count, current_bit} | rle_out;
    end
endmodule