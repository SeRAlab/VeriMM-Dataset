module lfsr (
    input wire clk,
    input wire reset,
    output reg [7:0] out
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            out <= 8'b10101010; // Seed value
        end else begin
            out <= {out[6:0], out[7] ^ out[5] ^ out[4] ^ out[3]};
        end
    end
endmodule