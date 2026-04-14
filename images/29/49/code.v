module rsa_encrypt (
    input wire [15:0] plaintext,
    input wire [15:0] n,
    input wire [3:0] e,
    input wire clk,
    input wire start,
    output reg [15:0] ciphertext,
    output reg done
);
    reg [15:0] temp;
    reg [3:0] count;

    always @(posedge clk) begin
        if (start) begin
            temp <= plaintext;
            ciphertext <= 16'b0;
            count <= 4'b0;
            done <= 1'b0;
        end else if (count < e) begin
            ciphertext <= (ciphertext + temp) % n;
            count <= count + 1;
        end else begin
            done <= 1'b1;
        end
    end
endmodule