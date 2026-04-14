module rle_encoder (
    input [3:0] data_in,
    output reg [1:0] rle_out
);
    integer i;
    reg [1:0] count;

    always @(*) begin
        count = 2'b00; // Reset count
        rle_out = 2'b00; // Default output

        for (i = 0; i < 4; i = i + 1) begin
            if (i == 0 || data_in[i] == data_in[i-1]) begin
                count = count + 1;
            end else begin
                rle_out = count;
                count = 2'b01; // Reset count for a new bit
            end
        end
        rle_out = count; // Final output
    end
endmodule