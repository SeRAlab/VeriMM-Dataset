module lfsr (
    input clk,
    input resetn,
    output [7:0] lfsr_out
);

    reg [7:0] lfsr_reg;  // 8-bit LFSR register

    always @(posedge clk) begin
        if (!resetn) begin
            lfsr_reg <= 8'b00000001;  // Reset the LFSR to initial state
        end else begin
            lfsr_reg <= {lfsr_reg[6:0], lfsr_reg[7] ^ lfsr_reg[5]};  // LFSR logic with taps at bit 8 and 6
        end
    end

    assign lfsr_out = lfsr_reg;

endmodule