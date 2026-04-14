module simple_DES (
    input wire [63:0] plaintext,
    input wire [63:0] key,
    output reg [63:0] ciphertext,
    input wire clk,
    input wire reset
);
    reg [63:0] L, R; // Left and Right halves
    reg [63:0] temp;
    integer i;

    // Initial permutation
    wire [63:0] IP = {plaintext[63:56], plaintext[55:48], plaintext[47:40], plaintext[39:32], 
                      plaintext[31:24], plaintext[23:16], plaintext[15:8], plaintext[7:0]};

    // Simplified F function (feistel)
    function [63:0] F;
        input [63:0] R;
        input [63:0] key;
        begin
            F = R ^ key; // Simple XOR for demonstration
        end
    endfunction

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            ciphertext <= 64'b0;
        end else begin
            L <= IP[63:32];
            R <= IP[31:0];
            for (i = 0; i < 16; i = i + 1) begin
                temp = R;
                R = L ^ F(R, key);
                L = temp;
            end
            ciphertext <= {R, L}; // Combine L and R
        end
    end
endmodule