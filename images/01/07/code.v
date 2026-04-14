module lfsr (
    input clk,
    input rst,
    input [4:0] seed,
    output reg [4:0] out
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            out <= seed;  // Load seed value on reset
        end else begin
            out <= {out[3:0], out[4] ^ out[2]}; // Shift and feedback from bits 5 and 3
        end
    end
endmodule