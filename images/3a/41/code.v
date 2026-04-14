module lfsr (
    input clk,
    input reset,
    output reg [4:0] out
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            out <= 5'b00000;
        end else begin
            out <= {out[3] ^ out[4], out[4:1]};
        end
    end
endmodule