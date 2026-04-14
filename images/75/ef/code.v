module fibonacci_lfsr (
    input clk,
    input reset,
    output [4:0] lfsr_out
);

    reg [4:0] lfsr_reg;

    always @(posedge clk) begin
        if (reset) begin
            lfsr_reg <= 5'b00001;  // Reset the LFSR to 1
        end else begin
            lfsr_reg <= {lfsr_reg[3:0], lfsr_reg[4] ^ lfsr_reg[2]};  // Shift and feedback
        end
    end

    assign lfsr_out = lfsr_reg;

endmodule