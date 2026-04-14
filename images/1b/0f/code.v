module lfsr_16bit (
    input clk,
    input rst,
    input [15:0] seed,
    output reg [15:0] out
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            out <= seed;
        end else begin
            out <= {out[14:0], out[15] ^ out[13] ^ out[11] ^ out[0]};
        end
    end
endmodule