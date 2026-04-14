module lfsr_16bit (
    input clk,
    input reset,
    input [15:0] seed,
    output reg [15:0] lfsr_out
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            lfsr_out <= seed;
        end else begin
            lfsr_out <= {lfsr_out[14:0], lfsr_out[15] ^ lfsr_out[13] ^ lfsr_out[12] ^ lfsr_out[10]};
        end
    end
endmodule