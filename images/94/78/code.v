module lfsr(
    input               clk,
    input               rst,
    input   [11:0]      seed,

    output reg [11:0]   out
);

always@(posedge clk or posedge rst) begin
    if (rst)
        out <= seed;
    else
        out <= {out[10:0], out[11] ^ out[10] ^ out[9] ^ out[3]};
end

endmodule