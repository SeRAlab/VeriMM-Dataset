module top_module (
    input clk,
    input sreset,
    input direction,
    input shift_enable,
    output [9:0] q );reg [9:0] q_reg;

always @(posedge clk) begin
    if (sreset)
        q_reg <= 10'b0000000000;
    else if (shift_enable) begin
        if (direction)
            q_reg <= {q_reg[8:0], 1'b0};
        else
            q_reg <= {1'b0, q_reg[9:1]};
    end
end

assign q = q_reg;

endmodule