module CSPRNG (
    input wire clk,
    input wire reset,
    input wire enable,
    input wire [4:0] seed,
    output reg [4:0] random_out
);
    reg [4:0] lfsr;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            lfsr <= seed;
            random_out <= seed;
        end else if (enable) begin
            lfsr <= {lfsr[3:0], lfsr[4] ^ lfsr[1]}; // example taps for a 5-bit LFSR
            random_out <= lfsr;
        end
    end
endmodule