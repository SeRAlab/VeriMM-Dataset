module aes_8bit (
    input wire [7:0] plaintext,
    input wire [127:0] key,
    input wire clk,
    input wire start,
    output reg [7:0] ciphertext,
    output reg done
);
    reg [7:0] state;
    reg [127:0] round_key;
    
    always @(posedge clk) begin
        if (start) begin
            // Initial round key addition
            round_key <= key;
            state <= plaintext ^ round_key[7:0]; // Use the first 8 bits of the key
            done <= 0; // Reset done flag
        end else begin
            // Simplified substitution step (for demonstration purpose)
            state <= {state[6:0], state[7]} ^ round_key[15:8]; // Rotate and XOR with next part of key
            ciphertext <= state;
            done <= 1; // Indicate encryption is done
        end
    end
endmodule