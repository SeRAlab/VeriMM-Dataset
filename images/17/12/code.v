module chacha20_update(
    input [31:0] key,
    input [31:0] nonce,
    output reg [31:0] state
);
    always @(*) begin
        state = key ^ nonce; // Simple XOR operation for state update
    end
endmodule