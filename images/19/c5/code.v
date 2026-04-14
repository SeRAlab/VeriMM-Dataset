module aes_8bit (
    input wire clk,
    input wire reset,
    input wire [7:0] plaintext,
    input wire [127:0] key,
    output reg [7:0] ciphertext,
    output reg done
);
    // Internal state and round counter
    reg [7:0] state;
    reg [3:0] round;

    // AES encryption process (simplified for 8-bit)
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= 8'b0;
            round <= 4'd0;
            ciphertext <= 8'b0;
            done <= 1'b0;
        end else begin
            // Simple representation of AES rounds
            if (round < 4'd10) begin
                // Example transformation (SubBytes, ShiftRows, MixColumns)
                state <= (state ^ plaintext) ^ key[round * 8 +: 8];
                round <= round + 1;
            end else begin
                ciphertext <= state;
                done <= 1'b1;
            end
        end
    end
endmodule