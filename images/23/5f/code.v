module aes_8bit (
    input wire [7:0] plaintext,
    input wire [7:0] key,
    input wire clk,
    output reg [7:0] ciphertext
);
    reg [7:0] state;
    reg [3:0] round;

    // Simplified AES steps (key mixing and substitution)
    function [7:0] substitute(input [7:0] data);
        begin
            // Simple substitution logic (for example, XOR with a constant)
            substitute = data ^ 8'h5A; // Substitute with a constant
        end
    endfunction

    always @(posedge clk) begin
        if (round == 0) begin
            state <= plaintext ^ key; // Initial key mixing
            round <= round + 1;
        end else if (round < 10) begin
            state <= substitute(state); // Apply substitution
            round <= round + 1;
        end else begin
            ciphertext <= state ^ key; // Final key mixing to produce ciphertext
            round <= 0; // Reset for next operation
        end
    end

    initial begin
        round = 0;
        ciphertext = 8'b0;
    end
endmodule