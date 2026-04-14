module register (
    input clk,
    input areset,
    input enable,
    input [9:0] data,
    output [9:0] q );reg [9:0] q_reg;

always @(posedge clk or posedge areset) begin
    if (areset)
        q_reg <= 10'b1111111111;
    else if (enable)
        q_reg <= data;
end

assign q = q_reg;

endmodule