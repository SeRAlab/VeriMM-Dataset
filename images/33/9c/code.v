module rsa_encrypt (
    input wire clk,
    input wire enable,
    input wire [7:0] plaintext,
    output reg [7:0] ciphertext
);
    reg [23:0] temp; // To hold intermediate calculations
    parameter e = 3;
    parameter n = 33;

    always @(posedge clk) begin
        if (enable) begin
            temp = plaintext ** e; // raise plaintext to the power of e
            ciphertext = temp % n; // take result mod n
        end
    end
endmodule