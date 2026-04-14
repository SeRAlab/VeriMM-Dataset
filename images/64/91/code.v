module fibonacci_lfsr (
    input clk,
    input reset,
    output [4:0] out
);

    reg [4:0] lfsr_reg;

    always @(posedge clk) begin
        if (reset) begin
            lfsr_reg <= 5'b1;  // Reset the LFSR to 1
        end else begin
            lfsr_reg <= {lfsr_reg[3:0], lfsr_reg[4] ^ lfsr_reg[2]};  // Fibonacci LFSR polynomial
        end
    end

    assign out = lfsr_reg;

endmodule