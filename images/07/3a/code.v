module rng_lfsr (
    input wire clk,
    input wire reset,
    input wire [15:0] seed,
    output reg [15:0] random_out
);

    reg [15:0] lfsr;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            lfsr <= seed; // Load seed on reset
            random_out <= 0;
        end else begin
            random_out <= lfsr; // Output current LFSR value
            // LFSR feedback polynomial: x^16 + x^14 + x^13 + x^11 + 1
            lfsr <= {lfsr[14:0], lfsr[15] ^ lfsr[13] ^ lfsr[11] ^ lfsr[0]};
        end
    end
endmodule