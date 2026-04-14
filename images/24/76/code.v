module des_like_encrypt (
    input wire clk,
    input wire reset,
    input wire [7:0] plaintext,
    input wire [7:0] key,
    output reg [7:0] ciphertext
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            ciphertext <= 8'b0;
        end else begin
            ciphertext <= plaintext ^ key;
        end
    end
endmodule