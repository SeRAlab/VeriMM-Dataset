module lfsr (
    input clk,
    input rst,
    input [31:0] seed,
    output reg [31:0] lfsr_out
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            lfsr_out <= seed;
        end else begin
            // Feedback polynomial: x^32 + x^22 + x^21 + x^1 + 1
            lfsr_out <= {lfsr_out[30:0], lfsr_out[31] ^ lfsr_out[21] ^ lfsr_out[20] ^ lfsr_out[0]};
        end
    end
endmodule