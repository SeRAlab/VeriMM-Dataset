module rsa_encrypt (
    input clk,
    input rst,
    input [15:0] plaintext,
    output reg [15:0] ciphertext
);
    reg [15:0] temp;
    reg [15:0] result;
    reg [7:0] count;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            temp <= 0;
            result <= 0;
            count <= 0;
            ciphertext <= 0;
        end else begin
            if (count < 3) begin
                if (count == 0) begin
                    temp <= plaintext;
                end
                result <= (result * temp) % 33; // Multiply and reduce mod n
                count <= count + 1;
            end else begin
                ciphertext <= result;
                count <= 0; // Reset for next encryption
            end
        end
    end
endmodule