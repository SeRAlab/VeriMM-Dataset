module LFSR (
    input clk,
    input rst,
    output reg [7:0] out
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            out <= 8'b00000001; // Initial value
        end else begin
            out <= {out[6:0], out[7] ^ out[5] ^ out[4] ^ out[3]}; // Feedback from the polynomial
        end
    end
endmodule