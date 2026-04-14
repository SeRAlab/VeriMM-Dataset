module lfsr (
    input clk,
    input reset,
    input [3:0] seed,
    output reg [3:0] lfsr_out
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            lfsr_out <= seed;
        end else begin
            lfsr_out <= {lfsr_out[2:0], lfsr_out[3] ^ lfsr_out[2]};
        end
    end
endmodule