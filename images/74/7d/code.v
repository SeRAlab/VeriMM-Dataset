module top_module (
    input clk,
    input sreset,
    input enable,
    input [11:0] data,
    output [11:0] q );reg [11:0] q_reg;

always @(posedge clk) begin
    if (sreset)
        q_reg <= 12'b000000000000;
    else if (enable)
        q_reg <= data;
end

assign q = q_reg;

endmodule