module chacha20_round (
    input [31:0] key,
    input [31:0] nonce,
    input [31:0] block_counter,
    output reg [31:0] result
);
    always @(key, nonce, block_counter) begin
        result <= (key + nonce + block_counter) % 32'hFFFFFFFF;
    end
endmodule