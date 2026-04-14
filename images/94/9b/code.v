module top_module(
    input clk,
    input [2047:0] in,
    output reg [5:0] out
);reg [3:0] shift_reg;
    reg [5:0] pop_count;

    always @(posedge clk) begin
        shift_reg[0] <= in[2047];
        shift_reg[1] <= shift_reg[0];
        shift_reg[2] <= shift_reg[1];
        shift_reg[3] <= shift_reg[2];

        pop_count = {shift_reg[3], shift_reg[2], shift_reg[1], shift_reg[0]};
        out <= $countones(pop_count);
    end

endmodule