module chacha20_state_update (
    input [31:0] key,
    input [31:0] nonce,
    input [31:0] counter,
    output reg [31:0] state
);
    always @(*) begin
        state = (key ^ nonce ^ counter) + 32'h1A2B3C4D; // XOR and add a constant
    end
endmodule