module fib_lfsr (
    input clk,
    input reset,
    output [15:0] lfsr_out
);

    reg [15:0] lfsr_reg;

    always @(posedge clk) begin
        if (reset) begin
            lfsr_reg <= 16'b1;  // Initialize LFSR with a non-zero value
        end else begin
            lfsr_reg <= {lfsr_reg[0], lfsr_reg[15:1] ^ {lfsr_reg[13], lfsr_reg[12], lfsr_reg[10]}};
        end
    end

    assign lfsr_out = lfsr_reg;

endmodule