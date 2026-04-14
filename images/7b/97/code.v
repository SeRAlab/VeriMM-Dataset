module top_module (
    input clk,
    input reset,
    input up,
    output [2:0] q);reg [2:0] q_reg;

always @(posedge clk) begin
    if (reset)
        q_reg <= 3'b111;
    else if (up)
        q_reg <= q_reg + 1;
    else
        q_reg <= q_reg - 1;
end

assign q = q_reg;

endmodule