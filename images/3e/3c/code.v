module chacha20_simple (
    input wire [31:0] key,
    input wire [63:0] nonce,
    input wire clk,
    input wire rst,
    output reg [31:0] keystream
);
    reg [31:0] state [0:3]; // 4 states for simplification
    integer i;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state[0] <= key;
            state[1] <= key ^ 32'h5a5a5a5a; // Some transformation
            state[2] <= nonce[31:0];
            state[3] <= nonce[63:32];
            keystream <= 32'b0;
        end else begin
            // Simplified permutation logic
            for (i = 0; i < 4; i = i + 1) begin
                state[i] <= {state[i][15:0], state[i][31:16]} + i; // Just a simple rotate and add
            end
            keystream <= state[0] ^ state[1] ^ state[2] ^ state[3]; // Produce keystream
        end
    end
endmodule