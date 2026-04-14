module lfsr_12bit(
    input clk,
    input reset,
    output reg [11:0] lfsr_out
);

always @(posedge clk or posedge reset) begin
    if (reset)
        lfsr_out <= 12'b000000000001;
    else
        lfsr_out <= {lfsr_out[10:0], lfsr_out[11] ^ lfsr_out[10] ^ lfsr_out[9] ^ lfsr_out[3]};
end

endmodule