module lfsr_32 (
    input clk,
    input reset,
    output reg [31:0] lfsr_out
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            lfsr_out <= 32'hFFFFFFFF; // reset state
        end else begin
            lfsr_out <= {lfsr_out[30:0], lfsr_out[31] ^ lfsr_out[21] ^ lfsr_out[20] ^ lfsr_out[16]};
        end
    end
endmodule