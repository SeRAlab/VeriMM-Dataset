module rsa_encrypt (
    input [7:0] plaintext,
    output reg [7:0] ciphertext,
    input clk,
    input reset
);
    parameter e = 3;
    parameter n = 33;
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            ciphertext <= 8'b0;
        end else begin
            if (plaintext < n) begin
                ciphertext <= (plaintext ** e) % n;
            end else begin
                ciphertext <= 8'b0; // Invalid input case
            end
        end
    end
endmodule