module aes_8bit (
    input clk,
    input rst,
    input valid,
    input [7:0] plaintext,
    output reg [7:0] ciphertext
);
    reg [7:0] state;

    // AddRoundKey (simple XOR with a constant key for demonstration)
    parameter KEY = 8'h1B; // Example key
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= 8'h00;
            ciphertext <= 8'h00;
        end else if (valid) begin
            // Step 1: AddRoundKey
            state <= plaintext ^ KEY;

            // Step 2: SubBytes (simple substitution for demonstration)
            state <= {state[6:0], state[7]}; // Rotate left (dummy substitution)

            // Step 3: ShiftRows (simple shift for demonstration)
            ciphertext <= {state[1:0], state[7:2]}; // Shift rows (dummy operation)
        end
    end
endmodule