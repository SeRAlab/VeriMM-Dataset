module chacha20_core (
    input clk,
    input reset,
    input [31:0] key,
    input [31:0] nonce,
    output reg [31:0] keystream
);
    reg [31:0] state;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= key ^ nonce; // Initialize state
            keystream <= 32'b0;
        end else begin
            // Simple LFSR-like feedback
            state <= {state[30:0], state[31] ^ state[0] ^ state[1] ^ state[2]};
            keystream <= state;
        end
    end
endmodule