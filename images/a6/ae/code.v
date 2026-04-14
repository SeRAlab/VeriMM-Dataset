module up_down_counter (
    input clk,
    input sreset,
    input enable,
    input up,
    output [31:0] q );reg [31:0] q_reg;

always @(posedge clk) begin
    if (sreset)
        q_reg <= 32'b0;
    else if (enable) begin
        if (up)
            q_reg <= q_reg + 1;
        else
            q_reg <= q_reg - 1;
    end
end

assign q = q_reg;

endmodule