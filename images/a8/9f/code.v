module fibonacci_lfsr (
    input clk,
    input clear_n,
    output reg [8:0] out
);always @(posedge clk) begin
    if (!clear_n) begin
        out <= 9'b000000001;
    end else begin
        out <= {out[7:0], out[8] ^ out[4]};
    end
end

endmodule