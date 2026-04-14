module lfsr_16bit (
    input clk,
    input rst,
    input [15:0] seed,
    output reg [15:0] lfsr_out
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            lfsr_out <= seed;
        end else begin
            // Feedback polynomial: x^16 + x^14 + x^13 + x^11 + 1
            lfsr_out <= {lfsr_out[14:0], lfsr_out[15] ^ lfsr_out[13] ^ lfsr_out[12] ^ lfsr_out[10]};
        end
    end
endmodule