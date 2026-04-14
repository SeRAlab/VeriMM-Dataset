module lfsr (
    input clk,
    input reset,
    output reg [5:0] out);always @(posedge clk) begin
    if (reset) begin
        out <= 6'b1;
    end else begin
        out <= {out[4:0], out[5] ^ out[4]};
    end
end
endmodule