module csprng_lfsr (
    input wire clk,
    input wire reset,
    input wire [4:0] seed,
    output reg [4:0] random_out
);
    reg [4:0] lfsr;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            lfsr <= seed;
            random_out <= seed; // Output the initial seed
        end else begin
            lfsr <= {lfsr[3:0], lfsr[4] ^ lfsr[2]}; // Feedback polynomial x^5 + x^3 + 1
            random_out <= lfsr;
        end
    end
endmodule