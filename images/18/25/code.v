module aes_encrypt (
    input [7:0] plaintext,
    input [7:0] key,
    output reg [7:0] ciphertext,
    input clk,
    input rst
);
    reg [7:0] state;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= 8'b0;
            ciphertext <= 8'b0;
        end else begin
            // AddRoundKey
            state <= plaintext ^ key;

            // SubBytes (simple lookup for 8 bits)
            state[7:4] <= state[7:4] ^ 4'b1010; // Example substitution
            state[3:0] <= state[3:0] ^ 4'b1100; // Example substitution

            // ShiftRows (no shift for 1 byte, just an example)
            state <= {state[6:0], state[7]}; // Rotate left

            // MixColumns (dummy mix for simplicity)
            state <= {state[6:0], state[7]} ^ 8'b11110000; // Example mix

            // Final AddRoundKey
            ciphertext <= state ^ key;
        end
    end
endmodule