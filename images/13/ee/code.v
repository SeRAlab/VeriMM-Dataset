module rsa_encrypt (
    input wire clk,
    input wire start,
    input wire [9:0] plaintext,
    input wire [9:0] n,
    input wire [9:0] e,
    output reg [19:0] ciphertext,
    output reg done
);
    reg [19:0] result;
    reg [9:0] temp_plaintext;
    reg [3:0] count;

    always @(posedge clk) begin
        if (start) begin
            temp_plaintext <= plaintext;
            result <= 1;
            count <= 0;
            done <= 0;
        end else if (count < e) begin
            result <= (result * temp_plaintext) % n;
            count <= count + 1;
        end else begin
            ciphertext <= result;
            done <= 1;
        end
    end
endmodule