module top_module(
    input clk,
    input [7:0] key,
    input [7:0] plaintext,
    output [7:0] ciphertext
);reg [7:0] shift_reg;
    wire [7:0] shifted_plaintext;
    wire [7:0] encrypted_output;

    // 8-bit shift register using D flip-flops
    always @(posedge clk) begin
        shift_reg[0] <= plaintext[0];
        shift_reg[1] <= shift_reg[0];
        shift_reg[2] <= shift_reg[1];
        shift_reg[3] <= shift_reg[2];
        shift_reg[4] <= shift_reg[3];
        shift_reg[5] <= shift_reg[4];
        shift_reg[6] <= shift_reg[5];
        shift_reg[7] <= shift_reg[6];
    end

    // Shifted plaintext output
    assign shifted_plaintext = shift_reg;

    // XOR gate for encryption
    assign encrypted_output = shifted_plaintext ^ key;

    // Output ciphertext
    assign ciphertext = encrypted_output;

endmodule