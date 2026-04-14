module CSPRNG (
    input wire clk,
    input wire reset,
    input wire [15:0] seed,
    output reg [15:0] random_number
);
    reg [15:0] lfsr;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            lfsr <= seed;
            random_number <= 16'h0000;
        end else begin
            // LFSR feedback polynomial: x^16 + x^14 + x^13 + x^11
            lfsr <= {lfsr[14:0], lfsr[15] ^ lfsr[13] ^ lfsr[12] ^ lfsr[10]};
            random_number <= lfsr;
        end
    end
endmodule