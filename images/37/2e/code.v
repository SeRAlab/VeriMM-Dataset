module CSPRNG (
    input clk,
    input reset,
    input enable,
    output reg [4:0] random_number
);
    reg [4:0] lfsr;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            lfsr <= 5'b00001; // Initial value (non-zero)
        end else if (enable) begin
            // LFSR feedback: taps at bits 5 and 4 (1-indexed)
            lfsr <= {lfsr[3:0], lfsr[4] ^ lfsr[0]};
        end
    end

    always @(posedge clk) begin
        if (enable) begin
            random_number <= lfsr;
        end
    end
endmodule