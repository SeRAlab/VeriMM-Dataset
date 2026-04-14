module lfsr (
    input clk,
    input rst,
    output reg [15:0] out
);

wire feedback = out[15] ^ out[13] ^ out[12] ^ out[10];

always @(posedge clk) begin
    if (rst)
        out <= 16'b1;
    else
        out <= {out[14:0], feedback};
end

endmodule