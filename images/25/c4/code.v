module lfsr (
    input clk,
    input reset,
    output reg [7:0] out
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            out <= 8'b00000001; // Non-zero initialization
        end else begin
            // LFSR feedback calculation using x^8 + x^6 + x^5 + x^4 + 1
            out <= {out[6:0], out[7] ^ out[5] ^ out[4] ^ out[3]};
        end
    end
endmodule