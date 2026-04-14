module aes_8bit (
    input wire clk,
    input wire rst,
    input wire [7:0] plain_text,
    input wire [7:0] key,
    output reg [7:0] cipher_text
);
    
    reg [7:0] state;
    reg [7:0] round_key;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            cipher_text <= 8'b0;
            state <= 8'b0;
            round_key <= 8'b0;
        end else begin
            // Simple AES-like operations (not real AES)
            // AddRoundKey
            round_key <= key ^ state;
            // SubBytes (simple example)
            state <= (round_key ^ 8'hAA); // Example substitution
            // ShiftRows (not implemented for simplicity)
            // MixColumns (not implemented for simplicity)
            // Final round key addition
            cipher_text <= state ^ round_key;
        end
    end
endmodule