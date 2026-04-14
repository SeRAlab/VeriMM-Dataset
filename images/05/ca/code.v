module aes_8bit (
    input wire clk,
    input wire reset,
    input wire [7:0] plaintext,
    input wire [7:0] key,
    output reg [7:0] ciphertext
);
    reg [7:0] state;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= 8'b0;
            ciphertext <= 8'b0;
        end else begin
            state <= plaintext ^ key; // AddRoundKey
            // A simplified round function (for demonstration)
            state <= {state[6:0], state[7]} ^ 8'h1B; // Shift and mix (simplified)
            ciphertext <= state; // Final output
        end
    end
endmodule