module LFSR_CSPRNG (
    input clk,
    input reset,
    input [4:0] seed,
    output reg [4:0] random_out
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            random_out <= seed;
        end else begin
            random_out <= {random_out[3:0], (random_out[4] ^ random_out[1])}; // Feedback from bit 4 and bit 2
        end
    end
endmodule