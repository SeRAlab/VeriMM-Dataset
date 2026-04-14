module rsa_encrypt (
    input [9:0] plaintext,
    output reg [9:0] ciphertext,
    input clk,
    input reset
);

parameter e = 3;
parameter n = 33;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        ciphertext <= 10'b0;
    end else begin
        ciphertext <= (plaintext ** e) % n; // Note: Verilog does not support '**', use a custom power function in real implementation
    end
end

endmodule