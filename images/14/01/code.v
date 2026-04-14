module lfsr_32bit (
    input clk,
    input rst,
    output reg [31:0] out
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            out <= 32'h1; // Initial state
        end else begin
            out <= {out[30:0], (out[31] ^ out[21] ^ out[22] ^ out[16] ^ out[15] ^ out[14] ^ out[13])};
        end
    end
endmodule