module chacha20 (
    input wire clk,
    input wire rst,
    input wire [31:0] plaintext,
    input wire [31:0] key,
    output reg [31:0] ciphertext
);

    reg [31:0] state [0:3]; // State array
    integer i;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // Initialize state
            state[0] <= key;
            state[1] <= plaintext;
            state[2] <= 32'hC0; // Constant for ChaCha20
            state[3] <= 32'h0;   // Round counter
            ciphertext <= 32'h0;
        end else begin
            // Simple round of the ChaCha20 process
            for (i = 0; i < 20; i = i + 1) begin
                state[0] <= state[0] + state[1]; // Add
                state[1] <= {state[1][15:0], state[1][31:16]}; // Rotate
                state[2] <= state[2] ^ state[0]; // XOR
                state[3] <= state[3] + 1; // Increment
            end
            ciphertext <= state[0] ^ state[1] ^ state[2] ^ state[3]; // Final output
        end
    end
endmodule