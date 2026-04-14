module LFSR_RNG (
    input clk,
    input reset,
    input [3:0] seed,
    output reg [3:0] random_number
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            random_number <= seed; // Load seed value on reset
        end else begin
            // LFSR feedback: XOR of bit 4 and bit 3
            random_number <= {random_number[2:0], random_number[3] ^ random_number[2]};
        end
    end
endmodule