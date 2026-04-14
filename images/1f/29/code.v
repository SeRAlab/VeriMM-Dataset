module LFSR (
    input clk,
    input rst,
    input [7:0] seed,
    output reg out
);
    reg [7:0] lfsr;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            lfsr <= seed;
        end else begin
            out <= lfsr[0]; // output the current LFSR value
            lfsr <= {lfsr[6:0], lfsr[7] ^ lfsr[5] ^ lfsr[4] ^ lfsr[0]}; // feedback polynomial
        end
    end
endmodule