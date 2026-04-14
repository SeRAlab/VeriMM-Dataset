module top_module (
    input clk,
    input sreset,
    input shift_enable,
    output [3:0] q );reg [3:0] q_reg;

always @(posedge clk) begin
    if (sreset)
        q_reg <= 4'b0000;
    else if (shift_enable)
        q_reg <= {1'b0, q_reg[3:1]};
end

assign q = q_reg;

endmodule