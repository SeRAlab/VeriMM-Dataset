module rng (
    input clk,
    input rst_n,
    input [7:0] seed,
    output reg [7:0] random_number
);
    reg [7:0] lfsr;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            lfsr <= seed;
            random_number <= 8'b0;
        end else begin
            lfsr <= {lfsr[6:0], lfsr[7] ^ lfsr[5] ^ lfsr[4] ^ lfsr[3]}; // Feedback using polynomial x^8 + x^6 + x^5 + x^4 + 1
            random_number <= lfsr;
        end
    end
endmodule