module chacha20_pipeline (
    input clk,
    input rst,
    input [31:0] key,
    input [31:0] nonce,
    output reg [31:0] keystream
);
    reg [31:0] nonce_reg;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            nonce_reg <= nonce;
            keystream <= 32'b0;
        end else begin
            keystream <= nonce_reg; // Output current nonce value as keystream
            nonce_reg <= nonce_reg + 1; // Increment nonce
        end
    end
endmodule