module DES (
    input [63:0] plaintext,
    input [63:0] key,
    output reg [63:0] ciphertext
);

    always @(*) begin
        ciphertext = plaintext ^ key; // Simplified DES operation
    end

endmodule