module chacha20_core (
    input wire [31:0] key,
    input wire [31:0] nonce,
    input wire [31:0] counter,
    output reg [31:0] keystream
);
    always @(key or nonce or counter) begin
        keystream = key + nonce + counter; // Simple addition to simulate keystream generation
    end
endmodule