module aes_8bit (
    input wire clk,
    input wire reset,
    input wire enable,
    input wire [7:0] plaintext,
    input wire [7:0] key,
    output reg [7:0] ciphertext
);
    reg [7:0] state;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= 8'b0;
            ciphertext <= 8'b0;
        end else if (enable) begin
            // Simple round function: XOR state with key
            state <= plaintext ^ key;
            // Output the ciphertext
            ciphertext <= state;
        end
    end
endmodule