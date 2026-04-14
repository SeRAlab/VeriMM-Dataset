module galois_lfsr (
    input clk,
    input reset,
    output [6:0] lfsr_out
);

    reg [6:0] lfsr_reg;

    always @(posedge clk) begin
        if (reset) begin
            lfsr_reg <= 7'b0000001;  // Reset the LFSR to 1
        end else begin
            lfsr_reg <= {lfsr_reg[5:0], lfsr_reg[6] ^ lfsr_reg[2]};  // Shift and feedback
        end
    end

    assign lfsr_out = lfsr_reg;

endmodule