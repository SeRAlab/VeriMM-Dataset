module lfsr (
    input wire clk,
    input wire reset,
    input wire [31:0] seed,
    output reg [31:0] lfsr_out
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            lfsr_out <= seed;
        end else begin
            lfsr_out <= {lfsr_out[30:0], lfsr_out[31] ^ lfsr_out[22] ^ lfsr_out[21] ^
                         lfsr_out[20] ^ lfsr_out[17] ^ lfsr_out[16] ^ lfsr_out[15] ^
                         lfsr_out[14] ^ lfsr_out[13] ^ lfsr_out[11] ^ lfsr_out[10] ^
                         lfsr_out[7] ^ lfsr_out[6] ^ lfsr_out[5] ^ lfsr_out[4] ^
                         lfsr_out[3] ^ lfsr_out[2]};
        end
    end
endmodule