module rle_compressor (
    input wire [7:0] data_in,
    output reg [31:0] compressed_out // Adjust size as necessary
);
    integer i;
    reg [3:0] count;
    
    always @* begin
        compressed_out = 0; // Reset output
        count = 1; // Reset count
        for (i = 0; i < 7; i = i + 1) begin
            if (data_in[i] == data_in[i + 1]) begin
                count = count + 1;
            end else begin
                // Append the current value and count to the output
                compressed_out = compressed_out | (data_in[i] << (6 - i) * 4) | (count << (2 - (7 - i)) * 4);
                count = 1; // Reset count
            end
        end
        // Handle the last value
        compressed_out = compressed_out | (data_in[7] << 0) | (count << 4);
    end
endmodule