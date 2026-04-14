module AES_AddRoundKey (
    input wire clk,
    input wire [127:0] plaintext,
    input wire [127:0] round_key,
    output reg [127:0] encrypted_text
);

always @(posedge clk) begin
    encrypted_text <= plaintext ^ round_key; // AddRoundKey transformation
end

endmodule