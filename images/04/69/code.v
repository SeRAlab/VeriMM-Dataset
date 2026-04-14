module lfsr_16bit (
    input clk,
    input reset,
    input enable,
    output reg [15:0] lfsr_out
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            lfsr_out <= 16'hACE1; // Initial seed
        end else if (enable) begin
            lfsr_out <= {lfsr_out[14:0], lfsr_out[15] ^ lfsr_out[13] ^ lfsr_out[11] ^ lfsr_out[10]};
        end
    end
endmodule