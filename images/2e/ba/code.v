module LFSR (
    input clk,
    input reset,
    input enable,
    input [15:0] seed,
    output reg [15:0] lfsr_out
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            lfsr_out <= seed;
        end else if (enable) begin
            lfsr_out <= {lfsr_out[14:0], lfsr_out[15] ^ lfsr_out[13] ^ lfsr_out[11] ^ lfsr_out[14]};
        end
    end
endmodule