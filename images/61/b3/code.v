module top_module
(
    input clk,
    input sreset,
    input [7:0] seed,
    output reg [7:0] lfsr
);always @(posedge clk)
        if (sreset) begin
            lfsr <= seed;
        end else begin
            lfsr <= {lfsr[6:0], lfsr[7] ^ lfsr[5] ^ lfsr[4] ^ lfsr[3]};
        end
endmodule