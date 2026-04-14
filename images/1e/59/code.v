module CSPRNG (
    input clk,
    input reset,
    input [4:0] seed,
    output reg [4:0] random_number
);
    reg [4:0] lfsr;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            lfsr <= seed; // Load the initial seed
            random_number <= 0;
        end else begin
            // LFSR feedback polynomial: x^5 + x^3 + 1
            lfsr <= {lfsr[3:0], lfsr[4] ^ lfsr[2]};
            random_number <= lfsr;
        end
    end
endmodule