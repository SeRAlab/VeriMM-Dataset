module lfsr
(
    input clk,
    input reset,
    output reg [9:0] lfsr_out
);
    always @(posedge clk) begin
        if (reset) begin
            lfsr_out <= 10'b0000000001; // Initialize LFSR to a non-zero value
        end else begin
            lfsr_out <= {lfsr_out[8:0], lfsr_out[9] ^ lfsr_out[6]}; // LFSR with taps at bit positions 10 and 7
        end
    end

endmodule