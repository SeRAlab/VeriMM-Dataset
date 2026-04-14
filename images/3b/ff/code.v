module lfsr_32bit (
    input clk,
    input reset,
    output reg [31:0] out
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            out <= 32'hFFFFFFFF; // Initial value
        end else begin
            out <= {out[30:0], out[31] ^ out[1] ^ out[21] ^ out[0]};
        end
    end
endmodule