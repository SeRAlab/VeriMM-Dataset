module chacha20_keystream (
    input wire clk,
    input wire [31:0] key,
    input wire [31:0] nonce,
    output reg [31:0] keystream
);
    always @(posedge clk) begin
        keystream <= key + nonce; // Simple addition for keystream generation
    end
endmodule