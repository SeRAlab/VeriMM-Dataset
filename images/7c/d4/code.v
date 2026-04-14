module counter (
    input clk,
    input sreset,
    input enable,
    output [5:0] q );reg [5:0] q_reg;

always @(posedge clk) begin
    if (sreset)
        q_reg <= 6'b000000;
    else if (enable)
        q_reg <= q_reg + 1;
end

assign q = q_reg;

endmodule