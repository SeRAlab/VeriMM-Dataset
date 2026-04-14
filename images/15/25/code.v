module AES_8bit (
    input clk,
    input reset,
    input [7:0] plaintext,
    input [127:0] key,
    output reg [7:0] ciphertext
);

reg [127:0] expanded_key;
reg [7:0] round_input;
reg [7:0] round_output;

// Key expansion (simple example)
always @(posedge clk or posedge reset) begin
    if (reset) begin
        expanded_key <= 128'h0;
    end else begin
        expanded_key <= {key[119:0], key[127:120]}; // Simple left shift for key expansion
    end
end

// Round operation (simple substitution for demonstration)
always @(posedge clk or posedge reset) begin
    if (reset) begin
        round_input <= 8'h0;
        ciphertext <= 8'h0;
    end else begin
        round_input <= plaintext ^ expanded_key[7:0]; // XOR with the first byte of expanded key
        round_output <= round_input + 8'h1; // Simple transformation
        ciphertext <= round_output; // Output ciphertext
    end
end

endmodule