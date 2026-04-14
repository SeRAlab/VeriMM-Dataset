module rng_lfsr (
    input wire clk,
    input wire reset,
    input wire enable,
    input wire [7:0] seed,
    output reg [7:0] random_out
);
    reg [7:0] lfsr;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            lfsr <= seed;
            random_out <= 8'b0;
        end else if (enable) begin
            lfsr <= {lfsr[6:0], lfsr[7] ^ lfsr[5] ^ lfsr[4] ^ lfsr[3]}; // Taps at 7, 5, 4, 3
            random_out <= lfsr;
        end
    end
endmodule