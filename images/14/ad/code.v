module chacha20_quarter_round (
    input wire clk,
    input wire reset,
    input wire [31:0] key,
    input wire [31:0] nonce,
    output reg [127:0] state
);
    reg [31:0] x0, x1, x2, x3;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Initialize state with the key and nonce
            x0 <= key;
            x1 <= nonce;
            x2 <= 32'h1; // constant for ChaCha20
            x3 <= 32'h0; // initial value
        end else begin
            // Perform quarter-round operation
            x0 <= x0 + x1; x3 <= (x3 ^ x0) >> 16;
            x2 <= x2 + x3; x1 <= (x1 ^ x2) >> 12;
            x0 <= x0 + x1; x3 <= (x3 ^ x0) >> 8;
            x2 <= x2 + x3; x1 <= (x1 ^ x2) >> 7;

            state <= {x0, x1, x2, x3}; // Update the state output
        end
    end
endmodule