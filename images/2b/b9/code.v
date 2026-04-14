module lfsr_32bit (
    input clk,
    input rst,
    output reg [31:0] out
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            out <= 32'hFFFFFFFF; // Reset state
        end else begin
            out <= {out[30:0], out[31] ^ out[22] ^ out[23] ^ out[17]};
        end
    end
endmodule