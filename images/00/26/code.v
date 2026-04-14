module aes_8bit (
    input wire [7:0] plaintext,
    input wire [7:0] key,
    input wire clk,
    input wire rst,
    output reg [7:0] ciphertext
);

reg [7:0] round_key;
reg [7:0] state;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        state <= 8'b0;
        round_key <= 8'b0;
        ciphertext <= 8'b0;
    end else begin
        // Key Expansion (for simplicity, directly assigning key for this example)
        round_key <= key;

        // AddRoundKey operation
        state <= plaintext ^ round_key;

        // Output ciphertext
        ciphertext <= state; // For one round
    end
end

endmodule