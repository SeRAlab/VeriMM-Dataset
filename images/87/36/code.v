module lfsr_6bit(
    input clk,
    input reset,
    output reg [5:0] lfsr_out
);

always @(posedge clk) begin
    if (reset)
        lfsr_out <= 6'b000001;
    else
        lfsr_out <= {lfsr_out[4:0], lfsr_out[5] ^ lfsr_out[4]};
end

endmodule