module lfsr_32bit(
    input clk,
    input rst_n,
    input en,
    output [31:0] lfsr_out
);

    reg [31:0] shift_reg;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            shift_reg <= 32'h1; // Non-zero seed value
        end else if (en) begin
            shift_reg <= {shift_reg[30:0], shift_reg[31] ^ shift_reg[21] ^ shift_reg[1] ^ shift_reg[0]};
        end
    end

    assign lfsr_out = shift_reg;

endmodule