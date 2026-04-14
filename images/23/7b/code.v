module chacha20_core (
    input clk,
    input rst,
    input [255:0] key,
    input [63:0] nonce,
    input [31:0] block_counter,
    output reg [511:0] keystream
);
    reg [31:0] state [0:15];
    integer i;

    initial begin
        keystream = 512'b0;
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state[0] <= 32'h61707865; // "expa"
            state[1] <= 32'h3320646e; // "nd 3"
            state[2] <= 32'h79622d32; // "2-by"
            state[3] <= 32'h6b206574; // "te k"
            state[4] <= key[255:224];
            state[5] <= key[223:192];
            state[6] <= key[191:160];
            state[7] <= key[159:128];
            state[8] <= key[127:96];
            state[9] <= key[95:64];
            state[10] <= key[63:32];
            state[11] <= key[31:0];
            state[12] <= 32'b0;
            state[13] <= 32'b0;
            state[14] <= block_counter;
            state[15] <= nonce[63:32];
        end else begin
            // ChaCha20 core operations
            // Simple example of state update (not actual ChaCha20 rounds)
            for (i = 0; i < 16; i = i + 1) begin
                state[i] <= state[i] + 1; // Increment for the sake of example
            end
            keystream <= {state[0], state[1], state[2], state[3], state[4], state[5], state[6], state[7], state[8], state[9], state[10], state[11], state[12], state[13], state[14], state[15]};
        end
    end
endmodule