module rsa_encrypt (
    input wire clk,
    input wire start,
    input wire [7:0] plaintext,
    output reg [7:0] ciphertext,
    output reg done
);
    reg [7:0] temp;
    
    always @(posedge clk) begin
        if (start) begin
            // RSA encryption: ciphertext = (plaintext^e) mod n
            // Using e = 3 and n = 33
            temp = plaintext * plaintext * plaintext; // plaintext^3
            ciphertext = temp % 33; // ciphertext = (plaintext^3) mod 33
            done = 1;
        end else begin
            done = 0;
        end
    end
endmodule