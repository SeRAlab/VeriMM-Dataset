module des_single_round (
    input [7:0] plaintext,
    input [7:0] key,
    output reg [7:0] ciphertext
);
    // Simple DES-like substitution box (S-box)
    reg [7:0] s_box [0:15];
    integer i;

    initial begin
        // Example S-box (the actual S-box would be more complex)
        s_box[0] = 8'b10101010;
        s_box[1] = 8'b01010101;
        s_box[2] = 8'b11110000;
        s_box[3] = 8'b00001111;
        s_box[4] = 8'b11001100;
        s_box[5] = 8'b00110011;
        s_box[6] = 8'b11111111;
        s_box[7] = 8'b00000000;
        s_box[8] = 8'b10011001;
        s_box[9] = 8'b01100110;
        s_box[10] = 8'b10100101;
        s_box[11] = 8'b01001010;
        s_box[12] = 8'b11010101;
        s_box[13] = 8'b00101110;
        s_box[14] = 8'b00011100;
        s_box[15] = 8'b11100011;
    end

    always @(*) begin
        // Simple key mixing and substitution
        ciphertext = s_box[(plaintext ^ key) % 16];
    end
endmodule