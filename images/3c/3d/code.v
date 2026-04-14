module chacha20_update (
    input wire [31:0] key,
    input wire [31:0] nonce,
    output reg [31:0] out
);
    always @(*) begin
        out = (key + nonce) ^ (key << 1);
    end
endmodule