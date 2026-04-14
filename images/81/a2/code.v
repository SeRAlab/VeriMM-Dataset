module lfsr (
    input clk,
    output reg [7:0] out);
    
    always @(posedge clk) begin
        out <= {out[6:0], out[7] ^ out[5] ^ out[4] ^ out[3]};
    end
endmodule