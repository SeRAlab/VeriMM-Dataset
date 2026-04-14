module CSPRNG (
    input clk,
    input reset,
    input [15:0] seed,
    input [4:0] num_bits,
    output reg [15:0] random_bits,
    output reg ready
);
    reg [15:0] lfsr;
    integer count;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            lfsr <= seed;
            random_bits <= 16'b0;
            ready <= 0;
            count <= 0;
        end else if (count < num_bits) begin
            ready <= 1;
            random_bits[count] <= lfsr[0]; // Output the least significant bit
            lfsr <= {lfsr[14:0], lfsr[15] ^ lfsr[13] ^ lfsr[11] ^ lfsr[10]}; // LFSR feedback
            count <= count + 1;
        end else begin
            ready <= 0; // No more bits to generate
        end
    end
endmodule