module lfsr (
    input clk,
    input reset,
    output [63:0] lfsr_out
);

    reg [63:0] lfsr_reg;

    always @(posedge clk) begin
        if (reset) begin
            lfsr_reg <= 64'b1;  // Initialize LFSR with a non-zero value
        end else begin
            lfsr_reg <= {lfsr_reg[62:0], lfsr_reg[63] ^ lfsr_reg[62] ^ lfsr_reg[60] ^ lfsr_reg[59]};
        end
    end

    assign lfsr_out = lfsr_reg;

endmodule