module CSPRNG (
    input clk,
    input rst,
    input [15:0] seed,
    output reg [15:0] random_number
);
    reg [15:0] lfsr;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            lfsr <= seed;
            random_number <= 16'b0;
        end else begin
            // LFSR feedback polynomial: x^16 + x^14 + x^13 + x^11 + 1
            lfsr <= {lfsr[14:0], lfsr[15] ^ lfsr[13] ^ lfsr[11] ^ lfsr[3]};
            random_number <= lfsr;
        end
    end
endmodule