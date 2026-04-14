module CSPRNG (
    input clk,
    input rst,
    input [4:0] seed,
    output reg [4:0] random_number
);
    reg [4:0] lfsr;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            lfsr <= seed;
        end else begin
            lfsr[0] <= lfsr[4] ^ lfsr[2]; // Taps at positions 5 and 3 (1-indexed)
            lfsr[1] <= lfsr[0];
            lfsr[2] <= lfsr[1];
            lfsr[3] <= lfsr[2];
            lfsr[4] <= lfsr[3];
        end
    end

    always @(posedge clk) begin
        random_number <= lfsr;
    end
endmodule